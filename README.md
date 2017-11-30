# docker-sqldeveloper-oracleclient

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
    
#### => connect via VNC viewer localhost:5901, default password: vncpassword
#### => connect via noVNC HTML5 client: http://localhost:6901/?password=vncpassword
