FROM centos:7
FROM grafana/grafana:latest

COPY runit.repo /etc/yum.repos.d/

RUN export USER=root && \
    /bin/echo "export USER=root" >> /root/.bashrc && \
    groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    yum -y install expect zlib rsyslog libaio boost file sudo libnl net-tools sysvinit-tools runit which psmisc lsof snappy rsync && \
    yum -y install mariadb-columnstore-client mariadb-columnstore-common mariadb-columnstore-libs mariadb-columnstore-platform mariadb-columnstore-server mariadb-columnstore-shared mariadb-columnstore-storage-engine && \
    yum clean all && \
    rm -rf /var/cache/yum