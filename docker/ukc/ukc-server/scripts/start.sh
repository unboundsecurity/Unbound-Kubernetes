#!/bin/bash
set -e

setup_ep() {
	/opt/ekm/bin/ekm_boot_ep.sh -s $HOSTNAME -p $1 -x $2 -f -w Password1! 2>/dev/null
	first_start
	echo "Checking UKC system..."
	until ucl server test &>/dev/null; do :; done
	echo "UKC system is installed"

	post_install
	service ekm restart
}

post_install() {
  echo "Executing post install commands"
  if [ "$UKC_NOCERT" == "true" ]
  then
	ucl system-settings set -k no-cert -v 1 -w Password1!
  fi

  if [ ! -z "$UKC_PARTITION" ] && [ ! -z "$UKC_PASSWORD" ]
  then
	echo "Creating partition: $UKC_PARTITION"
	ucl partition create -p $UKC_PARTITION -w Password1! -s $UKC_PASSWORD

	# echo "Changing partition 'so' password"
	# ucl user change-pwd -p $UKC_PARTITION -w Password1! -d $UKC_PASSWORD
  fi

  if [ ! -z "$UKC_PARTITION" ] && [ ! -z "$UKC_PARTITION_USER_PASSWORD" ]
  then
	echo "Changing '$UKC_PARTITION' partition 'user' password"
	ucl user change-pwd --user user -p $UKC_PARTITION -d $UKC_PARTITION_USER_PASSWORD
  fi

  if [ ! -z "$UKC_PASSWORD" ]
  then
	echo "Changing 'root' partition 'so' password"
	ucl user change-pwd -p root -w Password1! -d $UKC_PASSWORD
  fi

  # set server default certificate expiration to comply with Google trust maximum 825 days
  ucl system-settings set -k server-exp -v 730 -w $UKC_PASSWORD

  if [ ! -z "$UKC_CERTIFICATE_HOST_NAME" ]
  then
	echo "Adding additional hostnames and IP addresses: $UKC_CERTIFICATE_HOST_NAME"
	/opt/ekm/bin/ekm_renew_server_certificate.sh --name $UKC_CERTIFICATE_HOST_NAME
  fi

  ucl system-settings set -kx-DY_CHECK_JWT_ORIGINATOR -v0 -w $UKC_PASSWORD
}

setup_partner() {
    /opt/ekm/bin/ekm_boot_partner.sh -s $HOSTNAME -p $1 -x $2 -f
    first_start
}

setup_aux() {
  /opt/ekm/bin/ekm_boot_auxiliary.sh -s $HOSTNAME -e $1 -p $2 -f
  first_start
}

setup_additional() {
  /opt/ekm/bin/ekm_boot_additional_server.sh -s $1
  start_ukc
}

clean() {
	rm -rf /var/lib/ekm/*
	rm -rf /etc/ekm
	mkdir -p /etc/ekm/ssl
}

first_start() {
	#move config dir under /var/lib/ekm
	mv /etc/ekm /var/lib/ekm/etc
	ln -s /var/lib/ekm/etc /etc/ekm
	start_ukc
}

start_ukc() {
	echo "Starting UKC service"
  # configure trace log
  if [ $UKC_TRACE == "on" ]; then
      sed -i 's/TRACE\" additivity=\"false\" level=\"off\"/TRACE\" additivity=\"false\" level=\"trace\"/g' /opt/ekm/conf/log4j.xml
  fi
	/etc/init.d/ekm start
}

wait_for() {
    echo "Waiting for $1..."
    until ping -c1 $1 &>/dev/null; do :; done
    echo "$1 is up"
}

wait_for2() {
    echo "Waiting for $1..."
    until $([ "$http_code" == "200" ]); do
		http_code=$(curl -o /dev/null -s -w "%{http_code}\n" -k https://$1)
    done
    echo "$1 is up"
}

copy_resources() {
	# Copy data from the persistant volume is exists
	if [ -d "/mnt/casp" ];
	then
		cp /mnt/casp/casp_backup.pem /etc/ekm
	fi
}

if [ -e "/var/lib/ekm/ukc-installed" ]; then
	#link to the saved config
	rm -rf /etc/ekm
	ln -s /var/lib/ekm/etc /etc/ekm
	echo "Starting UKC $1"
	start_ukc
else
	clean
	echo "Setting up UKC $1 before first start.."
	K8S_NAMESPACE="default"
	K8S_DOMAIN="svc.cluster.local"
	K8S_SUFFIX=$K8S_NAMESPACE.$K8S_DOMAIN

  case "$1" in
    ep)
	  copy_resources
      setup_ep $2 $3
    ;;
    partner)
	  copy_resources
      setup_partner $2 $3
    ;;
    aux)
      setup_aux $2 $3
    ;;
    add-ep)
      UKC_EP=$3
      INDEX=${HOSTNAME##*-}
      PARTNER="$2-$INDEX"
      SERVICE_NAME=${HOSTNAME%-*}
      SRV_FULL_NAME=$HOSTNAME.$SERVICE_NAME.$K8S_SUFFIX
      PARTNER_FULL_NAME=$PARTNER.$2.$K8S_SUFFIX
      echo "Server full name is $SRV_FULL_NAME"
      echo "setup_additional starts"
      setup_additional $SRV_FULL_NAME
      echo "setup_additional done"

      wait_for2 $UKC_EP
      wait_for2 $PARTNER_FULL_NAME

      echo "checking UKC system health..."
      UKC_CHECK_COUNTER=12
      until $(curl -k https://$UKC_EP/api/v1/health &>/dev/null); do
        let UKC_CHECK_COUNTER-=1
        # echo UKC_CHECK_COUNTER $UKC_CHECK_COUNTER
        if [  $UKC_CHECK_COUNTER -lt 1 ];then
          exit 1
        fi
        sleep 5
      done

      set +e
      echo "pairing..."
      PAIRING_COUNTER=12
      until [  $PAIRING_COUNTER -lt 1 ]; do
        # echo PAIRING_COUNTER $PAIRING_COUNTER
        # echo curl -s -k -X POST -H 'Content-Type: application/json' --user so@root:$UKC_PASSWORD "https://$UKC_EP/api/v1/servers/new/pair?force=true" -d "{\"entryPoint\":{\"host\":\"$SRV_FULL_NAME\",\"port\":\"443\"},\"partner\":{\"host\":\"$PARTNER_FULL_NAME\",\"port\":\"443\"}}"
        curl -s -k -X POST -H 'Content-Type: application/json' --user so@root:$UKC_PASSWORD "https://$UKC_EP/api/v1/servers/new/pair?force=true" -d "{\"entryPoint\":{\"host\":\"$SRV_FULL_NAME\",\"port\":\"443\"},\"partner\":{\"host\":\"$PARTNER_FULL_NAME\",\"port\":\"443\"}}" &> newpair.response
        # echo "response:"
        # cat newpair.response
        pairok=`cat newpair.response | grep newServerCertificate`
        if [ -z "$pairok" ]
        then
          echo "retry"
          let PAIRING_COUNTER-=1
          # echo PAIRING_COUNTER $PAIRING_COUNTER
          sleep 5
        else
          echo "Pairing was OK"
          break
        fi

      done
      if [  $PAIRING_COUNTER -lt 1 ]
      then
        echo "Pairing failed"
        exit 1
      fi
      set -e

      echo "waitting for partner..."
      wait_for2 $PARTNER_FULL_NAME

      service ekm restart

      echo "checking UKC system health..."
      UKC_CHECK_COUNTER=12
      until $(curl -k https://$UKC_EP/api/v1/health &>/dev/null); do
        let UKC_CHECK_COUNTER-=1
        echo UKC_CHECK_COUNTER $UKC_CHECK_COUNTER
        if [  $UKC_CHECK_COUNTER -lt 1 ];then
          exit 1
        fi
        sleep 5
      done

      echo "pairing done"
    ;;
    add-partner)
	    SERVICE_NAME=${HOSTNAME%-*}
	    SRV_FULL_NAME=$HOSTNAME.$SERVICE_NAME.$K8S_SUFFIX
      echo "setup_additional starts"
      setup_additional $SRV_FULL_NAME
      echo "setup_additional done"
      SHA=`sha1sum /etc/ekm/ssl/root_ca.ks`
      echo -n "Waiting to be added..."
      while [ "`sha1sum /etc/ekm/ssl/root_ca.ks`" = "$SHA" ] ; do  sleep 5; done
      echo " Done"
      service ekm restart
    ;;
	esac
fi
echo "UKC system is ready"
touch /var/lib/ekm/ukc-installed
if [ "$1" != "aux" ]; then
	#run FluentD log collector agent
	td-agent -qq&
fi
tail -f /dev/null #keep container running



