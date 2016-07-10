#!bin/bash
# Script: list the hadoop jobs on HDFS.
# Detail: To list and kill and check status of hadoop jobs. 
# HowTo Run: chmod +x list_jobs.sh; ./list_jobs.sh
# Checks: status

job_killer(){

if [ "$1" == "userid" ]
then 
echo "Enter userid:"
read id
for jobid in `hadoop job -list | awk '$4 == "'$id'" {print $1}'`
do
hadoop job -kill $jobid
done
starter
elif [ "$id_type" == "jobid" ]
then
echo "Enter jobid: "
read id
hadoop job -kill $id
starter
else
echo "Invalid input please select enter userid or jobid"
reading
fi
}

reading(){
echo "Would you like see job status or kill job or exit <status or kill or exit>? :"
read input
decide  $input
}
job_list(){
> killme.txt
hadoop job -list > killme.txt
count=$(wc -l killme.txt | awk '{print $1}')
if [ "$count" == "2" ];then
echo "No jobs were running on HDFS"
exit -1
fi
if [ "$1" == "head"  ];
then
hadoop job -list | $1
reading
elif [ "$1" == "tail"  ];
then
hadoop job -list | $1
reading
elif [ "$1" == "all" ];
then
hadoop job -list
reading
elif [ "$1" == "exit" ];
then
exit -1
else
echo "invalid input"
starter
fi
}
starter(){
echo "Enter the following to list the jobs <head or tail or all> or <exit> to quit"
read value
job_list $value
}

decide(){
if [ "$1" == "exit" ];
then
exit -1
elif [ "$1" == "kill" ];
then
echo "Please enter word userid or jobid <userid or jobid>: "
read id_type
job_killer $id_type

elif [ "$1" == "status" ];
then
echo "please enter jobid:"
read jobid
hadoop job -status $jobid
reading

else
echo "Invalid input"
reading
fi
}
starter
