#!/bin/bash

component=$1

dnf install anisble -y

cd /home/ec2-user

git clone https://github.com/PrudhviMunakala/ansible-roboshop-roles.git

cd ansible-roboshop-roles

ansible-playbook -e component=$component roboshop.yaml

