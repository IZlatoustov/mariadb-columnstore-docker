mysql_install_db --user=root --datadir=/var/lib/mysql/1/
mysql_install_db --user=root --datadir=/var/lib/mysql/2/
mysql_install_db --user=root --datadir=/var/lib/mysql/3/
mysql_install_db --user=root --datadir=/var/lib/mysql/4/

mysqld_multi start 1
mysqld_multi start 2
mysqld_multi start 3
mysqld_multi start 4

### These starts do not happen immediate. This sleep is a low tech way to wait. Needs to be replaced with a proper check that loops for all four databases are up
sleep 15

mysql -h 127.0.0.1 -P 33061 < ./scripts/mariadb.sql 
mysql -h 127.0.0.1 -P 33062 < ./scripts/mariadb.sql 
mysql -h 127.0.0.1 -P 33063 < ./scripts/mariadb.sql 
mysql -h 127.0.0.1 -P 33064 < ./scripts/mariadb.sql 

sleep 15
mysql -h 127.0.0.1 -P 33061 < ./scripts/seed.sql

echo "Getting the bookstore data ..."
mkdir -p /tmp/bookstore/csv/
curl https://dl.dropboxusercontent.com/s/0z1iwdkw42cvr3d/fmc2.tar.gz?dl=1 --output /tmp/bookstore/csv/bookstore.tar.gz
echo "Extracting bookstore files ..."
tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/

echo "Loading Bookstore Sandbox Data ...."
mysql -h 127.0.0.1 -P 33061 <  /tmp/bookstore/sql/load_tx_template.sql 
