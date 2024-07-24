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
cpu_idle=$(echo "$vmstat_mb" | tail -n1 | awk '{print $15}'| xargs) #todo
cpu_kernel=$(echo "$vmstat_mb" | tail -n1 | awk '{print $14}'| xargs)
disk_io=$(echo "$vmstat_mb" | tail -n1 | awk '{print $10}'| xargs)
disk_available=$(df -BM --output=avail /)

# Current time in `2019-11-26 14:40:19` UTC format
timestamp=$(vmstat -t | awk 'NR==3 {print $18 " " $19}')

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
# PSQL command: Inserts server usage data into host_usage table
# Note: be careful with double and single quotes
insert_stmt="INSERT INTO host_usage(timestamp, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem) VALUES('$timestamp', #todo....

#set up env var for pql cmd
export PGPASSWORD=$psql_password
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?

# save the number of CPUs to a variable
lscpu_out=`lscpu`
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
# tip: `xargs` is a trick to remove leading and trailing white spaces
# tip: the $2 is instructing awk to find the second field

# hardware info
hostname= $(hostname -f)
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture= cpu_architecture=$(lscpu | grep Architecture | awk '{print $2}'| xargs)
cpu_model= $(lscpu | grep 'Model name' | awk -F': ' '{print $2}'|xargs)
cpu_mhz=$(grep -m 1 "cpu MHz" /proc/cpuinfo| awk -F': ' '{print $2}'|xargs)
l2_cache=$(lscpu | grep 'L2 cache' | awk -F': ' '{print $2}'|xargs)
total_mem=$(grep MemTotal /proc/meminfo| tail -1 |awk '{print $2}')
timestamp=$(date '+%Y-%m-%d %H:%M:%S')# current timestamp in `2019-11-26 14:40:19` format; use `date` cmd

# usage info
memory_free=$(vmstat --unit M | tail -1 | awk -v col="4" '{print $col}')
cpu_idle=$(vmstat | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat | tail -1 | awk '{print $14}')
disk_io=$(vmstat --unit M -d | tail -1 | awk -v col="10" '{print $col}')
disk_available=$(df -BM --output=avail /)