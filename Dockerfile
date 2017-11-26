FROM centos/systemd
MAINTAINER Melih Savdert

# Install Required Packages
RUN yum install -y yum-utils openssh openssh-server openssh-clients openssl-libs xterm xauth libXtst libaio.x86_64 glibc.x86_64 && yum clean all

# JDK Installation
RUN wget -c -O /tmp/jdk-9.0.1_linux-x64_bin.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.rpm
RUN yum -y localinstall /tmp/jdk-*

# Oracle Client 12.2 Installation
ADD oracle-instantclient12.2-* /tmp/
RUN yum -y localinstall /tmp/oracle* --nogpgcheck

# Oracle Sqldeveloper Installation
ADD sqldeveloper-* /tmp/

RUN yum -y localinstall /tmp/sqldeveloper-* 

# Remove Installation Files
RUN rm -f /tmp/*

#Enable sshd service
RUN systemctl enable sshd

# set environment variable
ENV JAVA_HOME=/usr/java/latest
ENV PATH=$PATH:$JAVA_HOME/bin

CMD ["/usr/sbin/init"]
