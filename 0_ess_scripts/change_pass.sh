#!/bin/bash

echo "ec2-user:DevOps321" | sudo chpasswd 
sed -i -e "s|PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config
systemctl restart sshd