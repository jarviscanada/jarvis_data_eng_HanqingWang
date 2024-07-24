#! /bin/sh

# Capture CLI arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#check for # of args
if ["$#" -ne 5]; then
  echo "Illegal number of parameters"
  exit 1
fi
# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
# save hostname as a variable
hostname=$(hostname -f)


# Retrieve hardware specification variables
# xargs is a trick to trim leading and trailing white spaces
memory_free=$(echo "$vmstat_mb" | awk '{print $4}'| tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | tail -n1 | awk '{print $15}'| xargs)
cpu_kernel=$(echo "$vmstat_mb" | tail -n1 | awk '{print $14}'| xargs)
disk_io=$(echo "$vmstat_mb" | tail -n1 | awk '{print $10}'| xargs)
disk_available=$(df -BM --output=avail /)

# Current time in `2019-11-26 14:40:19` UTC format
timestamp=$(vmstat -t | awk 'NR==3 {print $18 " " $19}')

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
# PSQL command: Inserts server usage data into host_usage table
# Note: be careful with double and single quotes
insert_stmt="INSERT INTO host_usage(timestamp,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available) VALUES('$timestamp','$memory_free','$cpu_idle','$cpu_kernel','$disk_io','$disk_available')

#set up env var for pql cmd
export PGPASSWORD=$psql_password
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?


