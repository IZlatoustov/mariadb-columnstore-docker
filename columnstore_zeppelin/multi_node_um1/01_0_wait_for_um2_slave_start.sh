#!/bin/sh
echo "Waiting for UM2 to respond"

MAX_TRIES=36
if [ ! -z "$CS_WAIT_ATTEMPTS" ]; then
    MAX_TRIES=$CS_WAIT_ATTEMPTS
fi

# if argument is -d enable debug output
if [ $# -gt 0 ] && [ "$1" == "-d" ]; then
    CS_DEBUG=1
fi

ATTEMPT=1
# this essentiall waits for the root @um1 login to be created as well as the slave to be started.
STATUS=$(/usr/local/mariadb/columnstore/mysql/bin/mysql -u root -h um2 -e "show slave status\G" | grep "Waiting for master")
while [ 1 -eq $? ] && [ $ATTEMPT -le $MAX_TRIES ]; do
    if [ ! -z $CS_DEBUG ]; then
        echo "wait_for_um2_slave_start($ATTEMPT/$MAX_TRIES): $STATUS"
    fi
    sleep 5
    ATTEMPT=$(($ATTEMPT+1))
    STATUS=$(/usr/local/mariadb/columnstore/mysql/bin/mysql -u root -h um2 -e "show slave status\G" | grep "Waiting for master")
done

if [ $ATTEMPT -ge $MAX_TRIES ]; then
    echo "ERROR: Did not detect slave start on um2 after $MAX_TRIES attempts"
    exit 1
fi

exit 0
