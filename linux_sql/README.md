
# Introduction
The objective of the Linux Cluster monitoring project is to create a monitoring program that automatically tracks CPU usage on the JARVIS remote desktop. Monitoring CPU usage is crucial for obtaining important information about your virtual environment. By tracking CPU usage, administrators can ensure the system runs efficiently, troubleshoot potential issues, and plan for future resource needs.

This program tracks several key CPU usage parameters, including free memory, idle and kernel CPU time, disk input/output operations, and disk free space. Docker is used to create containers, ensuring the application runs consistently across different environments. Bash scripts are created to automate commands that extract and save CPU usage data. Git is utilized as the primary version control system, helping developers track changes in the source code during software development.
# Quick Start
In this section, we will look at some quick start commands to implement the monitoring program. 
1. Start a psql instance using psql_docker.sh
  - To start a psql instance, users need to define the host name(HOST_NAME), user name(USER_NAME) and database name(DB_name). Port number should be set to 5432 which is the TCP port used by the PostgreSQL Database Server.
  ```
  psql -h HOST_NAME -p 5432 -U USER_NAME -d DB_NAME 
  ```
2. Create tables using ddl.sql
  - To execute the ddl.sql file against the psql instance, users should input the preset host, user and database name.
  ```
  psql -h HOST_NAME -p 5432 -U USER_NAME -d DB_NAME -f ddl.sql
  ```

3. Insert hardware specs data into the DB using host_info.sh
  - To call up and run host_info.sh script, we need define two additional variables which are psql username(psql_USER) and password(psql_PASSWORD).
```
./scripts/host_info.sh HOST_NAME 5432 DB_NAME psql_USER psql_PASSWORD
```
4. Insert hardware usage data into the DB using host_usage.sh
- Follow the same steps to run host_usage.sh script.
```
./scripts/host_usage.sh HOST_NAME 5432 DB_NAME psql_USER psql_PASSWORD
```
5. Crontab setup
- We can set up the Crontab tool to automate the host_usage.sh to collect CPU usage data continuously.
- Simplly type ` crontab -e ` to edit crontab script.
- If we want to collect data every minute use syntax `* * * * *`
```
  * * * * * bash /FULL/FILE/PATH/host_usage.sh HOST_NAME 5432 DB_NAME psql_USER psql_PASSWORD > /tmp/host_usage.log
```
- Note that the full file path of the host_usage.sh script can be obtained using `pwd` .
# Implemenation
This section outlines the architecture of the Linux Cluster monitoring agent and discusses the scripts and syntaxes used to help users gain a better understanding of the program.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

## Scripts
In this section, we will look at the function of each script and its usage.
### psql_doscker.sh
The script `psql_docker.sh` is designed to manage a PostgreSQL Docker container named jrvs-psql. It handles three command-line arguments to determine the desired action and to gather database credentials. Initially, it ensures that Docker is running,
```
sudo systemctl status docker || sudo systemctl start docker
```
followed by checking the status of the specified container.
```
  docker container inspect jrvs-psql
  container_status=$?
```
If the container exists, the above argument will return 0, otherwise it will return 1.
The script supports three primary commands: `create`, `start`, and `stop`. The create command verifies if the container already exists and, if not, creates it using the provided database username and password while setting up a Docker volume for persistent storage. The start and stop commands control the running state of an existing container. 
### host_info.sh
`host_info.sh` script captures detailed hardware specifications and records them into a PostgreSQL database. It requires five command-line arguments: `HOST_NAME` `PORT_NUMBER` `DB_NAME` `psql_USER` `psql_PASSWORD`. The script is run only once since the virtual machine statistics remain the same. Initially, the script ensures that the correct number of arguments is provided.
```
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi
```
It then gathers various machine statistics, including the number of CPUs, CPU architecture, CPU model, CPU frequency, L2 cache size, and total memory, along with the current timestamp. Using these metrics, the script constructs a SQL `INSERT` statement to record the data into a table named host_info. For secure connection, the PostgreSQL password is set as an environment variable. The script then uses the psql command-line tool to insert the data into the host_usage table in the database.
### host_usage.sh
```host_usage.sh``` records CPU and memory usage such as the number of CPUs, CPU architecture, CPU model, CPU frequency, L2 cache size, and total memory with the current timestamp. Similarly, the script accepts five arguments and checks the validity of the arguments provided.  The script matches entries with the same `host_name` in `host_usage` table and retrieves the `host_id`. 
```
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
```
After collecting all the necessary information, the script stores the data into `host_info` table under the same database.
### crontab
The Crontab script schedules automatic execution of `host_usage.sh` script at a one-minute interval. The results are saved to a log file for debugging and monitoring. 

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

# Test
How did you test your bash scripts DDL? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware updates 
- blah
- blah
