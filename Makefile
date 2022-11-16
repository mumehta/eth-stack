.DEFAULT_GOAL:=help

.PHONY: all 
all: help

.PHONY: help
help: ## all make options 
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: build
build: ## build docker image
	docker build -t ubu-wi-ssh .

.PHONY: run
run: # run containers
	for target in target1 target2 target3 ; \
	do \
		docker run -d -P --rm --name $$target -h $$target ubu-wi-ssh ; \
		sed -i "s/$$target/`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$target`/2" inventory.txt ; \
	done

.PHONY: stop
stop: ## stop containers
	for target in target1 target2 target3 ; \
	do \
		docker stop $$target ; \
		unset $$target ; \
		sed -i "s/$$target ansible_host=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$$target ansible_host=$$target/g" inventory.txt ; \
	done ; 

.PHONY: play
play: ## run playbook
	ansible-playbook playbook.yml -i inventory.txt

