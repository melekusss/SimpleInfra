#!/bin/bash
yum -y update
yum -y install httpd
echo "<h2>Super WebServer</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on