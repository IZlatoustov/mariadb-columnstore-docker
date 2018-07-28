#!/bin/bash
echo "Getting the bookstore data ..."
curl https://dl.dropboxusercontent.com/s/pthwm41k30qbbid/fmc.tar.gz?dl=1 --output /tmp/bookstore/csv/bookstore.tar.gz

echo "Extracting bookstore files ..."
tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/

echo "Waiting for columnstore to respond (2m)."
i=0
until (/usr/local/mariadb/columnstore/bin/mcsadmin getSystemStatus|grep -c "System        ACTIVE" > /dev/null 2>&1)
    do
        if [ "$i" =  "24" ]; then
          break
        fi
        i=$(( $i+1 ))
        sleep 5s
        echo "Retry" $i
    done
echo "Loading Bookstore Sandbox Data ...."
/usr/local/mariadb/columnstore/mysql/bin/mysql < /tmp/bookstore/sql/load_ax_template.sql