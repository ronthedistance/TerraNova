#! /bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install python -y
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y