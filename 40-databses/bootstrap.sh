#!/bin/bash

component=$1
environment=$2

dnf install ansible -y

cd /home/ec2-user

git clone https://github.com/PrudhviMunakala/ansible-roboshop-roles.git

cd ansible-roboshop-roles

git pull

ansible-playbook -e component=$component -e environment=$environment roboshop.yaml

