#!/bin/bash
ansible-galaxy collection install kubernetes.core

ansible-playbook -i hosts playbook_vm.yml
ansible-playbook playbook_aks.yml