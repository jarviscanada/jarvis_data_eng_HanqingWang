# Introduction
The objective of this Linux project is to create a monitoring program that automatically tracks CPU usage on the JARVIS remote desktop. Monitoring CPU usage is crucial for obtaining important information about your virtual environment. By tracking CPU usage, administrators can ensure the system runs efficiently, troubleshoot potential issues, and plan for future resource needs.

This program tracks several key CPU usage parameters, including free memory, idle and kernel CPU time, disk input/output operations, and disk free space. Docker is used to create containers, ensuring the application runs consistently across different environments. Bash scripts are created to automate commands that extract and save CPU usage data. Git is utilized as the primary version control system, helping developers track changes in the source code during software development.
# Quick Start
Use markdown code block for your quick-start commands
- Start a psql instance using psql_docker.sh
- Create tables using ddl.sql
- Insert hardware specs data into the DB using host_info.sh
- Insert hardware usage data into the DB using host_usage.sh
- Crontab setup
-
# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

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
