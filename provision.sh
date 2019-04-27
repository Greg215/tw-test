#!/bin/bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --vault-password-file .vault-pass.txt site.yml -v -e 'ansible_python_interpreter=/usr/bin/python3'
