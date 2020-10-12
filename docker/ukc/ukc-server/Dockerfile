FROM centos:8

LABEL maintainer "Unbound Tech"

# Download & install Java, Tomcat, OpenSSL...
RUN yum -y update;\
    yum -y install wget ;\
    yum -y install openssl initscripts unzip;\
    yum -y install initscripts;\
    yum clean all;

#OpenJDK Java 11
RUN curl -sO https://download.oracle.com/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz ;\
    mv jdk-11.0.2 /usr/local/
RUN ln -s /usr/local/jdk-11.0.2/bin/java /usr/bin/java
RUN rm /openjdk-11.0.2_linux-x64_bin.tar.gz

ENV JAVA_HOME=/usr/local/jdk-11.0.2
ENV PATH=$PATH:$JAVA_HOME/bin

#install FluentD (aka td-agent) log collector
RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent4.sh | sed 's/sudo//g' | sh
#mongoDb plugin
RUN yum -y install gcc make;\
	td-agent-gem install fluent-plugin-mongo;\
	yum -y remove gcc make
COPY data/td-agent.conf /etc/td-agent
COPY data/parser_ekm_time_line.rb /etc/td-agent/plugin

#install UKC
COPY data/ekm*.el8.x86_64.rpm /ekm-RHES.x86_64.rpm
RUN rpm -i /ekm-RHES.x86_64.rpm ;\
	rm /ekm-RHES.x86_64.rpm

COPY scripts /scripts
RUN chmod +x /scripts/*

EXPOSE 8443
EXPOSE 433
ENTRYPOINT ["/scripts/start.sh"]