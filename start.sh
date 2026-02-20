#!/bin/bash
echo "Cleaning up locks..."
rm -rf /var/run/apache2/* /var/run/mysqld/*

echo "Setting up permissions..."
mkdir -p /var/run/mysqld /var/run/apache2
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chown -R www-data:www-data /var/run/apache2

echo "Starting MySQL..."
# Use the explicit init script included in the DVWA image
/etc/init.d/mysql start

# IMPORTANT: Wait 3 seconds to let the database fully initialize
echo "Waiting for database to wake up..."
sleep 3

echo "Starting Apache..."
source /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND