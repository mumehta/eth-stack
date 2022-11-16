# eth-stack  

## Pre-requisites

1. Make use of host machine or preferrably launch a virtual machine with docker and ansible pre-installed

2. Clone the repo `https://github.com/mumehta/eth-stack` and navigate to project root

## How to use

### About

The project makes use of ansible playbook https://github.com/mrlesmithjr/ansible-mariadb-galera-cluster and applies on docker-containers. The end state is galera-cluster running on containers.

For easy manoeuvre the project makes use of `Make`.
 
make  
```
help:  all make options 
build:  build docker image
stop:  stop containers
play:  run playbook
```

Build Docker image  
	`make build`  

Run Containers  
	`make run` 

Stop and clean containers  
	`make stop`  
 
Run ansible playbook  
	`make play`  

## Launch Galera cluster on containers

1. Run below targets sequentially

- `make stop`
- `make build`  
- `make run`  
- `make play`  

The `make run` updates the `inventory` on the run. `make apply` plays ansible playbook on launched containers to create cluster.

2. Verify if cluster is up and running

`docker exec -it target1 bash`

```
root@target1:/# mysql -uroot -p

MariaDB [(none)]> create database test;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> use test
Database changed
MariaDB [test]> create table user (id int auto_increment primary key, username varchar(20), when datetime) ;
Query OK, 0 rows affected (0.056 sec)

MariaDB [test]> insert into user (username,when) values (@@hostname,now());
Query OK, 1 row affected (0.005 sec)
```

Similarly, check on other containers and in mysql, you should see `test` database and `user` table

2. Stop and clean  
`make stop`  
This will restore `inventory.txt` for using again with `make` commands.


## Setup mysql root user after cluster launch

1. From docker container, connect to `mysql`  

	`docker exec -it target1 bash`  
	`mysql`  
	```
	MariaDB [(none)]> -- CREATE ROOT USER FOR WILDCARD HOST;
	MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
	Query OK, 0 rows affected (0.057 sec)

	MariaDB [(none)]> FLUSH PRIVILEGES;
	Query OK, 0 rows affected (0.048 sec)

	MariaDB [(none)]> exit
	Bye
	root@target1:/# exit
	exit
	```   
2. 	Now you should be able to connect to galara from host machine  - replace `172.17.0.4` belo with any docker ip (can see inventory.txt file)  

	```
	mysql -uroot -p -h172.17.0.4
	Enter password: 
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 47
	Server version: 5.5.5-10.6.11-MariaDB-1:10.6.11+maria~ubu2004 mariadb.org binary distribution

	Copyright (c) 2000, 2022, Oracle and/or its affiliates.

	Oracle is a registered trademark of Oracle Corporation and/or its
	affiliates. Other names may be trademarks of their respective
	owners.

	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

	mysql> show databases;
	+--------------------+
	| Database           |
	+--------------------+
	| information_schema |
	| mysql              |
	| performance_schema |
	| sys                |
	+--------------------+
	4 rows in set (0.03 sec)

	mysql> exit
	Bye
	```


