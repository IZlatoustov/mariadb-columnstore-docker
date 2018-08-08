# MariaDB AX Columnstore Sandbox with Zeppelin Notebooks
 
## Building
- Install docker: https://docs.docker.com/engine/installation/
- Run docker build to create the docker image, feel free to choose your own container name other than mariadb/columnstore:

Make sure you are in columnstore_zeppelin folder
```sh
$ cd columnstore_zeppelin
```

Build columnstore
```sh
$ docker build -t mariadb/columnstore:latest ../columnstore
```

Build zeppelin instance.
```sh
$ docker build -t mariadb/columnstore_zeppelin:latest ../columnstore_zeppelin
```

Bring the whole cluster up
```sh
$ docker-compose up --build -d
```

It can take up to 10 min before the cluster starts and the data is ingested. 

The status of data ingest can be tracked in the UM1 container log file.

```sh
$ docker logs -f columnstore_zeppelin_um1_1
```

Open Zeppelin from this link
[http://localhost:8080](http://localhost:8080)

