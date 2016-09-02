#!/bin/bash

NUM_OF_NODES=5

[[ -f /tmp/$(date +%d+%m+%Y).acta.storage.txt  ]] && rm /tmp/$(date +%d+%m+%Y).acta.storage.txt || printf "Do Nothing"
[[ -f /tmp/$(date +%d+%m+%Y).acta.storage.df.txt  ]] && rm /tmp/$(date +%d+%m+%Y).acta.storage.df.txt || printf "Do Nothing"
[[ -f /tmp/acta.pre.run.check.log  ]] && rm /tmp/acta.pre.run.check.log || printf "Do Nothing"

echo "[INFO] ACTA Pre-run check @ $(date)" 

acta-run-on-all 'df' > /tmp/$(date +%d+%m+%Y).acta.storage.df.txt
acta-run-on-all 'df' | awk '{print $5}' > /tmp/$(date +%d+%m+%Y).acta.storage.txt

echo "[INFO] Testing avialable storage for btrfs snapshots"

for i in $(cat /tmp/$(date +%d+%m+%Y).acta.storage.txt)
	do 
		if [[ $(echo $i |grep -o '[0-9]*') > 40 ]]
			then 
			echo '[ERROR] One of more disk have more than half Used Storage' >> /tmp/acta.pre.run.check.log
			echo '[ERROR] btrfs snapshop backups will fail' >> /tmp/acta.pre.run.check.log
			
			fi	
	 done

echo "[INFO] Testing ACTA project jar"

[[ $(ls /usr/local/acta/jars/actaproject.jar | grep -o actaproject.jar) ]] || echo '[ERROR] Project.jar is not in the $ACTA_HOME/jars/' >> /tmp/acta.pre.run.check.log

echo "[INFO] Testing Cassandra"

if  $(nodetool -p 7199 status | grep -q  DN)
then 
 	echo "[ERROR] At lease one cassandra node is  down" >> /tmp/acta.pre.run.check.log
	nodetool -p 7199 status | grep  DN  >> /tmp/acta.pre.run.check.log
fi 

echo "[INFO] Testing Hadoop"

if [[ $(hdfs dfsadmin -report | grep "Live datanodes" | awk '{print $3}' | grep -o [0-9]) != $NUM_OF_NODES ]]
then
        echo "[ERROR] At lease one Hadoop node is  down" >> /tmp/acta.pre.run.check.log
       # nodetool -p 7199 status | grep  DN  >> /tmp/acta.pre.run.check.log
	hdfs dfsadmin -report >> /tmp/acta.pre.run.check.log
fi

echo "[INFO] Testing ACTA manage analytic process"
[[ -f /data/run/acta-managed-analytics.lock ]] && echo "[ERROR] a instance of acta-managed-analytics is running on the cluster, type ps -ef | acta-manage for more details " >> /tmp/acta.pre.run.check.log

echo "[INFO] Printing the resutls"
sleep 1
echo " "
echo " "
echo "ACTA pre-requsites test for prior Analytic run Report"
echo "-----------------------------------------------------"


if [[ -a /tmp/acta.pre.run.check.log ]] 
then
	
	echo -e  "\033[31m[ERROR] Please fix the error and re-run the tool"
	cat /tmp/acta.pre.run.check.log
	 echo -e  "\033[0m "
else 
	 echo -e  "\033[32m [SUCCESS] ACTA Pre-analytic test are Completed. ACTA is ready for the weekend run \033[0m"
	 echo "w3m http://localhost:8888 can provide spark cluster details"
fi

