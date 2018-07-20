#!/bin/bash
echo "Getting the bookstore data ..."
curl https://dl.dropboxusercontent.com/s/c9lya7px62srd0a/twelve_mil.tar.gz?dl=1 --output /tmp/bookstore/csv/dropbox.tar.gz
echo "Extracting bookstore files ..."
tar -vxzf /tmp/bookstore/csv/dropbox.tar.gz --directory /tmp/bookstore/csv/

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