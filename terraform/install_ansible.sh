#! /bin/bash
sudo apt-get update -y
sudo apt-get install python -y
sudo apt-get install software-properties-common -y
sudo apt-get-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y
#<append your extra keys to the authorized_keys file>