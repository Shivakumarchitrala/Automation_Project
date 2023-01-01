# Automatation Script commit in Dev branch and merge with main branch
#!/bin/bash
myname=shiva
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=upgrad-shivakumarbucket


#  To check if Apache is already installed
if ! type "apache2" > /dev/null; then
  # If Apache is not installed, install it
  sudo apt-get update
  sudo apt-get install apache2
  echo "Apache HTTP server installed"
else
  # If Apache is already installed, print a message
  echo "Apache HTTP server is already installed"
fi

# Check if Apache is running
if ! systemctl is-active --quiet apache2; then
  # If Apache is not running, start it
  sudo systemctl start apache2
  echo "Apache HTTP server successfully started"
else
  # If Apache is already running, print a message
  echo "Apache HTTP server is already running"
fi

# To check if Apache set to restart on reboot
if ! systemctl is-enabled --quiet apache2; then
  # If Apache is not set to start on boot, enable it
  sudo systemctl enable apache2
  echo "Apache HTTP server successfully enabled to start on boot"
else
  # If Apache is already set to start on boot, print a message
  echo "Apache HTTP server is already enabled to start on boot"
fi



tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar


if test -f "/var/www/html/inventory.html"; then
  # File exists
  echo "File exists"
else
  # File does not exist
  echo "File does not exist"
  touch /var/www/html/inventory.html
  echo Log_type Time_Created Type Size >> /var/www/html/inventory.html
fi



# Define variables
log_type="htppd logs"
archive_date=${timestamp}
archive_type="tar"
archive_size=$(du -h "/tmp/${myname}-httpd-logs-${timestamp}.tar" | awk '{print $1}')

# Create new entry in inventory.html
echo "<tr>" >> /var/www/html/inventory.html
echo "  <td>$log_type</td>" >> /var/www/html/inventory.html
echo "  <td>$archive_date</td>" >> /var/www/html/inventory.html
echo "  <td>$archive_type</td>" >> /var/www/html/inventory.html
echo "  <td>$archive_size</td>" >> /var/www/html/inventory.html
echo "</tr>" >> /var/www/html/inventory.html

