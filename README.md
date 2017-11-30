# docker-sqldeveloper-oracleclient

### The following pre-installed VNC server image is used as the base image.

https://hub.docker.com/r/consol/centos-xfce-vnc/

### Cloning Repository

    git clone https://github.com/msavdert/docker-sqldeveloper-oracleclient
    cd docker-sqldeveloper-oracleclient/

### Get the following files from 

    Instant Client Downloads for Linux x86-64
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

	• oracle-instantclient12.1-basic-12.2.0.1.0-1.x86_64.rpm
	• oracle-instantclient12.1-devel-12.2.0.1.0-1.x86_64.rpm
	• oracle-instantclient12.1-sqlplus-12.2.0.1.0-1.x86_64.rpm

### Download latest SQL Developer and JDK for Linux

#### SQL Developer
    http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html
#### JDK
    jdk-8u151-linux-x64.rpm
    wget -c -O jdk-8u151-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm

### Build Dockerfile (make sure all the files you downloaded are in the same directory with Dockerfile)

    $ ls -l
    total 578596
    -rw-rw-r-- 1 docker docker       935 Nov 30 19:57 Dockerfile
    -rw-rw-r-- 1 docker docker 174163338 Oct  9 22:30 jdk-8u151-linux-x64.rpm
    -rw-rw-r-- 1 docker docker  52826628 Mar  1  2017 oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
    -rw-rw-r-- 1 docker docker    606864 Mar  1  2017 oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
    -rw-rw-r-- 1 docker docker    708104 Mar  1  2017 oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm
    -rw-rw-r-- 1 docker docker        34 Nov 30 19:57 README.md
    -rw-rw-r-- 1 docker docker 364154996 Oct 17 18:41 sqldeveloper-17.3.1.279.0537-1.noarch.rpm
    
    docker build -t melihsavdert/oracleclient .

### Start a container named "client"

    docker run --rm \
    --privileged \
    --detach \
    --name client \
    -h client.example.com \
    -p 5901:5901 -p 6901:6901 \
    --net pub \
    --add-host nfs:192.168.100.20 \
    --ip 192.168.100.30 \
    -e TZ=Europe/Istanbul \
    --user 0 \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    melihsavdert/oracleclient

### Configure /etc/resolv.conf for DNS
    
    docker exec -it client cp /etc/resolv.conf /tmp/resolv.conf && \
    docker exec -it client sed -i '/search/s/$/ example.com\nnameserver 192.168.100.20/' /tmp/resolv.conf && \
    docker exec -it client cp -f /tmp/resolv.conf /etc/resolv.conf
  
  #### Check DNS resolving rac-scan SCAN ips
  
    $ docker exec -it client nslookup rac-scan
    Server:		192.168.100.20
    Address:	192.168.100.20#53

    Name:	rac-scan.example.com
    Address: 192.168.100.15
    Name:	rac-scan.example.com
    Address: 192.168.100.14
    Name:	rac-scan.example.com
    Address: 192.168.100.16

#### => connect via VNC viewer <ip-address>:5901, default password: vncpassword
#### => connect via noVNC HTML5 client: http://<ip-address>:6901/?password=vncpassword

![crsctl](https://image.prntscr.com/image/nbnN54kVT5ahaaLCxnB4YQ.png)
![crsctl](https://image.prntscr.com/image/aCT0bC5XQ8uEKPK7mTLEuA.png)
![crsctl](https://image.prntscr.com/image/I6Jg8gsBT_WqqOEJuAfK9A.png)

    docker exec -it client mkdir -p /usr/lib/oracle/12.2/client64/network/admin
    docker exec -it client vi /usr/lib/oracle/12.2/client64/network/admin/tnsnames.ora

    RAC=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac-scan.example.com)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=RAC)(FAILOVER_MODE=(TYPE=select)(METHOD=basic))))
    RAC1=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac1-vip.example.com)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SID=RAC1)))
    RAC2=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=rac1-vip.example.com)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SID=RAC2)))

![crsctl](https://image.prntscr.com/image/k9Sg4thiQXmj_Pp6vP_0ag.png)
![crsctl](https://image.prntscr.com/image/O0XFiEOhRHuPPP4hUy40Ew.png)

#### Or with basic method

![crsctl](https://image.prntscr.com/image/Hw9Z2-0uTzKQBBM2h2Rk1Q.png)
![crsctl](https://image.prntscr.com/image/-UANahLCQFmFjwPGIfq0Yw.png)


