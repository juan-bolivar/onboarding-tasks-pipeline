.PHONY: concourse
.ONESHELL:

include credentials.env
export $( sed 's/=.*//' credentials.env)
cputype=$(shell sysctl -n machdep.cpu.brand_string  )

concourse:
	curl -O https://concourse-ci.org/docker-compose.yml
ifeq ('$(cputype)','Apple M1 Pro') 
	sed -i.bak 's/image: concourse\/concourse/image: rdclda\/concourse:7.8.2/' docker-compose.yml'
	#sed -i.bak  's/containerd/houdini/' docker-compose.yml
endif
	docker-compose up -d
	curl 'http://localhost:8080/api/v1/cli?arch=amd64&platform=darwin' -o fly  && chmod +x ./fly 
	./fly -t infra-concourse login -c http://localhost:8080 -u test -p test
	./fly -t infra-concourse set-pipeline -p infra -c concurseCI/pipeline.yaml \
		-v AWS_KEY=$(AWS_ACCESS_KEY_ID)\
		-v AWS_SECRET=$(AWS_SECRET_ACCESS_KEY)\
		-v AWS_REGION=$(AWS_REGION)\
		-v AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)\
		-v DATADOG_API_KEY=$(DATADOG_API_KEY)\
		-v DATADOG_APP_KEY=$(DATADOG_APP_KEY)\
		-v GITHUB_USER=$(GITHUB_USER)\
		-v GITHUB_TOKEN=$(GITHUB_TOKEN) 
	./fly -t infra-concourse unpause-pipeline -p infra
