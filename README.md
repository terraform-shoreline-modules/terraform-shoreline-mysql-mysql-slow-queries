
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MySQL slow queries incident
---

A MySQL slow queries incident is when a MySQL server is experiencing slow queries. This can result in degraded performance and responsiveness of the system. It is important to resolve this incident quickly to minimize impact on users.

### Parameters
```shell
# Environment Variables

export USERNAME="PLACEHOLDER"

export PASSWORD="PLACEHOLDER"

export CLIENT_IP_ADDRESS="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"

```

## Debug

### 1. Check the overall CPU and memory usage of the server
```shell
top
```

### 2. Check the MySQL process list to identify any long-running queries
```shell
mysql -u ${USERNAME} -p${PASSWORD} -e "SHOW FULL PROCESSLIST;"
```

### 3. Check the MySQL slow query log file for any recent entries
```shell
sudo tail -n 100 /var/log/mysql/mysql-slow.log
```

### 4. Check the MySQL configuration file for any misconfigurations
```shell
cat /etc/mysql/my.cnf
```

### 5. Check the disk usage of the server to ensure there is enough space
```shell
df -h
```

### 6. Check the system logs for any relevant errors or warnings
```shell
sudo tail -n 100 /var/log/syslog
```

### 7. Check the network connectivity between the server and client
```shell
ping ${CLIENT_IP_ADDRESS}
```

### 8. Check the status of the MySQL service
```shell
sudo systemctl status mysql.service
```

### Lack of appropriate indexes on database tables causing slow query performance.
```shell

#!/bin/bash

# Define variables

DB_NAME=${DATABASE_NAME}

DB_USER=${USERNAME}

DB_PASSWORD=${PASSWORD}

SLOW_QUERY="PLACEHOLDER"

# Connect to the database and run EXPLAIN on a sample slow query

mysql -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME; EXPLAIN ${SLOW_QUERY}"

# Check output of EXPLAIN to see if any indexes are missing

if [[ $(mysql -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME; EXPLAIN ${SLOW_QUERY}" | grep 'Using where') ]]; then

    echo "Query is using WHERE and no indexes are being used."

    echo "Add appropriate indexes to improve query performance."

else

    echo "Query is using indexes appropriately."

fi

```

## Repair

### Set MySQL credentials
```shell
DB_USER=${USERNAME}

DB_PASS=${PASSWORD}
```
### Connect to MySQL and optimize tables
```shell
mysql -u $DB_USER -p$DB_PASS -e "USE ${DATABASE_NAME}; OPTIMIZE TABLE ${TABLE_NAME};"
```

### Increase the number of database connections to handle more traffic and reduce the likelihood of slow queries.
```shell

#!/bin/bash

# Set variables

MAX_CONNECTIONS="PLACEHOLDER"

# Increase maximum connections in MySQL config file

sudo sed -i "s/max_connections=.*/max_connections=$MAX_CONNECTIONS/" /etc/mysql/my.cnf

# Restart MySQL service

sudo systemctl restart mysql

# Verify the change

mysql -u $DB_USER -p$DB_PASS -h $DB_HOST -e "SHOW VARIABLES LIKE 'max_connections'" $DB_NAME


```