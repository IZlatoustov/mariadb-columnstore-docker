# txworkshop

## Summary ##
This image can be used for testing, [labs](labs/),demos, etc.

 # Environment #
This docker image has 4 mariadb instances installed running on different ports:

Maxscale - 3306
 
Mariadb1 - 33061
 
Mariadb2 - 33062
 
Mariadb3 - 33063
 
Mariadb4 - 33064

# Getting Started #
To startup the nodes run:

``` 
$ docker build . -t txworkshop
$ docker run --name txworkshop -d -it -h txworkshop txworkshop
```
To connect to maxscale node via mysql:

```
$ mysql -h 127.0.0.1 -u maxuser -p -P 3306
The password is "password"
```
To connect to Mariadb1 example:

```
$ mysql -h 127.0.0.1 -u maxuser -p -P 33061
The password is "password"
```

To start (or stop) an individual MariaDB node:
```
$ mysqld_multi start 1 ### Starts node 1
$ mysqld_multi stop  1 ### Stops node 1
```
