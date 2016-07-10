# Script: Node Health Script
# Detail: To Check Single Node Health.
# HowTo Run: chmod +x nodeHealthCheck.sh; ./nodeHealthCheck.sh
# Checks: loadavg, memory, cpu, cpu test, nfs mounts

## LoadAvg Function
loadavg() {
LoadAvg=`uptime | awk -F "load average:" '{print $2}' | cut -f 1 -d,`
echo "LoadAvg = $LoadAvg" >> $Report
}

## Memory Function
memory() {

TOTAL_MEM=`grep "MemTotal:" /proc/meminfo | awk '{msum+=($2/1024)/1024} END {printf "%.0f",msum}'`
FREE_MEM=`grep "MemFree:" /proc/meminfo | awk '{mfree+=($2/1024)/1024} END {printf "%.0f",mfree}'`

TOTAL_SWAP=`grep "SwapTotal:" /proc/meminfo | awk '{ssum+=($2/1024)/1024} END {printf "%.0f",ssum}'`
FREE_SWAP=`grep "SwapFree:" /proc/meminfo | awk '{sfree+=($2/1024)/1024} END {printf "%.0f",sfree}'`

echo "TotalMemory = $TOTAL_MEM GB ($FREE_MEM GB Free)" >> $Report
echo "TotalSwap = $TOTAL_SWAP GB ($FREE_SWAP GB Free)" >> $Report
}

## CPU Function
cpu() {
PROCESSOR=`grep processor /proc/cpuinfo | wc -l`
CPU_MODEL=`grep "model name" /proc/cpuinfo | head -n 1 | awk '{print $7 " " $8 " " $9}'`

echo "Processors = $PROCESSOR" >> $Report
echo "ProcessorModel = $CPU_MODEL" >> $Report
}

## NFS Mounts Function
nfs() {
NFS_MOUNTS=`mount -t nfs,panfs,gpfs | wc -l`

echo "NFS_MOUNTS = $NFS_MOUNTS" >> $Report
}

### MAIN SCRIPT

## Get Node Name
Hostname=`hostname -s`
touch ./$Hostname-checks.txt
Report=./$Hostname-checks.txt
echo " " > $Report
echo "Node = ${Hostname}" >> $Report
echo "-----------------------" >> $Report

## Get Cluster Name
Cluster=`echo $Hostname | cut -c1-4`

## Call Function
memory
loadavg
cpu
nfs

## Generate Report
echo " " >> $Report
cat $Report
rm -rf $Report