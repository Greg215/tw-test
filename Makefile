.PHONY: all
all: ansibleclean buildByAnsible deployByAnsible

setup:
ifndef DOCKER_TAG
DOCKER_TAG = "localtest-$(shell git rev-parse --short HEAD)"
endif

ifndef IMAGES_TAG
IMAGES_TAG = "localtest"
endif

ifndef IMAGES
IMAGES := $(shell docker images |  grep "${IMAGES_TAG}" | sed 's/ \+ /\t/g' | cut -f 3 | sort | uniq)
endif

ifndef ENVIRONMENT
ENVIRONMENT = "dev"
endif

cleanupImages: setup
ifneq ($(IMAGES),)
	echo $(IMAGES)
	docker rmi -f $(IMAGES)
endif

ansibleclean: setup
	- docker rmi -f $(DOCKER_TAG)_ap_ansible_configure || true

buildByAnsible: setup
	docker build --pull=true -t $(DOCKER_TAG)_ap_ansible_license -f Dockerfile.ansible .
	docker run --rm -t \
	--name $(DOCKER_TAG)_ap_ansible_license --rm $(DOCKER_TAG)_ap_ansible_license \
	sh -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory -v site.yml'

deployByAnsible: setup
	docker build --pull=true -t $(DOCKER_TAG)_ap_ansible_license -f Dockerfile.ansible .
	docker run --rm -t \
	--name $(DOCKER_TAG)_ap_ansible_license --rm $(DOCKER_TAG)_ap_ansible_license \
	sh -c 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory -v site.yml'
