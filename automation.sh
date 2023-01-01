# Automatation Script commit in Dev branch and merge with main branch
#!/bin/bash
myname=shiva
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=upgrad-shivakumarbucket

sudo apt-get update -y
apt-get install apache2 -y
systemctl status apache2
service apache2 status
sudo update-rc.d apache2 enable

tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

