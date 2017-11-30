FROM consol/centos-xfce-vnc
MAINTAINER Melih Savdert

USER root
WORKDIR /root

# set environment variable
ENV JAVA_HOME=/usr/java/latest
ENV PATH=$PATH:$JAVA_HOME/bin

# Install Required Packages
RUN yum install -y yum-utils libaio.x86_64 glibc.x86_64 bind-utils && yum clean all

# JDK Installation
ADD jdk-* /tmp/
RUN yum -y localinstall /tmp/jdk-* --nogpgcheck

# Oracle Client 12.2 Installation
ADD oracle-instantclient12.2-* /tmp/
RUN yum -y localinstall /tmp/oracle* --nogpgcheck

# Oracle Sqldeveloper Installation
ADD sqldeveloper-* /tmp/

RUN yum -y localinstall /tmp/sqldeveloper-* 

# Remove Installation Files
RUN rm -f /tmp/*

CMD ["/usr/sbin/init"]
