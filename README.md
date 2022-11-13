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


