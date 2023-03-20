#!/bin/bash

ansible-playbook -i hosts playbook_vm.yml
ansible-playbook playbook_aks.yml