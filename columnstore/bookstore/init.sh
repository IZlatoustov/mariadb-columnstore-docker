#!/bin/bash
echo "Extracting bookstore files ..."
for f in /bookstore/csv/*.csv.gz; do
    case "$f" in
        echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
    esac
    echo
done

echo "Waiting for columnstore to respond (1m)."
i=0
until (/usr/local/mariadb/columnstore/bin/mcsadmin getSystemStatus|grep -c "System        ACTIVE" > /dev/null 2>&1)
    do
        if [ "$i" =  "12" ]; then
          break
        fi
        i=$(( $i+1 ))
        sleep 5s
        echo "Retry " + $i
    done
echo "Loading Bookstore Sandbox Data ...."
exec /usr/local/mariadb/columnstore/mysql/bin/mysql < /tmp/bookstore/sql/load.sql