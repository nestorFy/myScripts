#!/bin/env bash

#log err
keep_log="/tmp/keepalived_script.log"


mysql_con='mysql -uxxxx -pxxxx'
$mysql_con -e 'SET GLOBAL event_scheduler=0;'
$mysql_con -e 'SET GLOBAL read_only=1;'
###这里其实是一个批量kill线程的小技巧
#$mysql_con -e 'select concat("kill ",id,";") from  information_schema.PROCESSLIST where command="Query" or command="Execute" into outfile "/tmp/kill.sql";'
#$mysql_con -e "source /tmp/kill.sql;"
$mysql_con -e 'START SLAVE;'

echo "$(date) 成为备库，开启slave，库只读" >> ${keep_log}
