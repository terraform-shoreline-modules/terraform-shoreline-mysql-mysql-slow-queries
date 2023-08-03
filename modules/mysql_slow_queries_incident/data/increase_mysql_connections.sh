
#!/bin/bash

# Set variables

MAX_CONNECTIONS="PLACEHOLDER"

# Increase maximum connections in MySQL config file

sudo sed -i "s/max_connections=.*/max_connections=$MAX_CONNECTIONS/" /etc/mysql/my.cnf

# Restart MySQL service

sudo systemctl restart mysql

# Verify the change

mysql -u $DB_USER -p$DB_PASS -h $DB_HOST -e "SHOW VARIABLES LIKE 'max_connections'" $DB_NAME