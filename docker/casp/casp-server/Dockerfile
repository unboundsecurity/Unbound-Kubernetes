FROM centos:7

LABEL maintainer "Unbound Tech"

RUN yum -y update;\
    yum -y install which ;\
    yum -y install wget ;\
    yum -y install sudo ;\
    yum -y install openssl;\
    yum -y install nano;\
    yum -y install sleep;\
    yum clean all;


#OpenJDK Java 11
RUN curl -sO https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/
RUN ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java
RUN rm /openjdk-11.0.2_linux-x64_bin.tar.gz


ENV JAVA_HOME=/usr/local/jdk-11.0.2
ENV PATH=$PATH:$JAVA_HOME/bin

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - ;\
    yum clean all && sudo yum makecache fast ;\
    yum install -y nodejs

RUN yum -y install httpd httpd-tools mod_ssl;\
    systemctl enable httpd;\
    echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

#for psql commands
RUN yum -y install postgresql

#install FluentD (aka td-agent) log collector
RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent4.sh | sed 's/sudo//g' | sh
#mongoDb plugin
RUN yum -y install gcc make;\
	td-agent-gem install fluent-plugin-mongo;\
	yum -y remove gcc make
COPY data/td-agent.conf /etc/td-agent
COPY data/parser_casp_time_line.rb /etc/td-agent/plugin

#install CASP
COPY data/casp*-RHES.x86_64.rpm /casp-RHES.x86_64.rpm
RUN rpm -i /casp-RHES.x86_64.rpm ;\
    rm /casp-RHES.x86_64.rpm
COPY data/casp-apache-redirect.conf /etc/httpd/conf.d/

COPY data/start.sh /
RUN chmod +x /start.sh

EXPOSE 443
ENTRYPOINT ["/start.sh"]
CMD [ "start" ]
