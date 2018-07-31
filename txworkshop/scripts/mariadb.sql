
create user 'maxuser'@'%' identified by 'password';
grant SELECT on mysql.user to 'maxuser'@'%';
GRANT SELECT ON mysql.db TO 'maxuser'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxuser'@'%';
GRANT SUPER ON *.* TO 'maxuser'@'%';
grant RELOAD on *.* to 'maxuser'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxuser'@'%';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'maxuser'@'%';
GRANT REPLICATION CLIENT on *.* to 'maxuser'@'%';
GRANT REPLICATION SLAVE ON *.* TO 'maxuser'@'%';

create user 'maxuser'@'localhost' identified by 'password';
grant SELECT on mysql.user to 'maxuser'@'localhost';
GRANT SELECT ON mysql.db TO 'maxuser'@'localhost';
GRANT SELECT ON mysql.tables_priv TO 'maxuser'@'localhost';
GRANT SUPER ON *.* TO 'maxuser'@'localhost';
grant RELOAD on *.* to 'maxuser'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'maxuser'@'localhost';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'maxuser'@'localhost';
GRANT REPLICATION CLIENT on *.* to 'maxuser'@'localhost';
GRANT REPLICATION SLAVE ON *.* TO 'maxuser'@'localhost';



RESET MASTER;

DELIMITER |
IF @@server_id  > 1 THEN
  CHANGE MASTER TO
    MASTER_HOST='localhost',
    MASTER_USER='maxuser',
    MASTER_PASSWORD='password',
    MASTER_PORT=33061,
    MASTER_CONNECT_RETRY=10,
    master_use_gtid=current_pos;
  START SLAVE;
END IF |
DELIMITER ;
