DELIMITER |
IF @@server_id = 1 THEN
 CREATE DATABASE sales;
 create table sales.customer (fname varchar(50), lname varchar (50), ssn varchar(9));
 insert into sales.customer values ('Johnny','Rello','221121212');
END IF |
DELIMITER ;