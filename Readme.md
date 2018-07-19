# MariaDB ColumnStore Docker Repository
This repository contains varying docker configurations for MariaDB ColumnStore:
- columnstore : Simple non production single server ColumnStore server
- columnstore_jupyter : Demonstrates the MariaDB ColumnStore Spark Connector running with a Jupyter notebook.

# Initializing a fresh instance
When a container is started for the first time, a new database with the name bookstore will be created. Furthermore, it will automatically load bookstore data into the **bookstore** schema. 