#!/bin/sh

echo "Creating /etc/apache2/httpd.conf (workaround for Debian/Ubuntu Apache2 modifications)"
touch /etc/apache2/httpd.conf

echo "Running OpenAM Apache Web Agent installer..."
echo "password" > /tmp/password.txt
./agentadmin --install --acceptLicense --useResponse install_responses.txt
rm /tmp/password.txt

echo "Setting up agent configuration in Apache2"
mv /etc/apache2/httpd.conf /etc/apache2/conf-available/openam-apachewa.conf

echo "Enabling web agent configuration"
a2enconf openam-apachewa

echo "Starting runit!"
/sbin/my_init
