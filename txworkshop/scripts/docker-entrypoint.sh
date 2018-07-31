#!/bin/bash
mysqld_multi start 1
mysqld_multi start 2
mysqld_multi start 3
mysqld_multi start 4
mysql -h 127.0.0.1 -P 33061 < /usr/share/mysql/install_spider.sql
sudo -u maxscale /usr/bin/maxscale &
exec "$@"
bash
