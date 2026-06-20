#!/bin/bash 

sudo id -u 
sudo dnf install nginx -y 
echo "nginx install complete" 
sudo systemctl restart nginx 
