# eth-stack
1. Build docker image
	`docker build -t ubu-wi-ssh -f Dockerfile-ubuntu-with-ssh .`
2. Run ubuntu container with ssh capability - 3 times - change name target1/target2/target3 in below command
	`docker run -d -P --rm --name target3 ubu-wi-ssh`
	2.1 Get container ip address
		`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' target3`
	2.2 populate ansible inventory - inventory.txt (in project repo)
	2.3 disable strict key checking - for ansible to do ssh in docker containers - ansible.cfg
3. Install mariadb galera cluster
	`ansible-playbook playbook.yml -i inventory.txt`
