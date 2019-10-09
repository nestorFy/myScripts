#!/bin/env bash
mysql_bin="/data/tools/mysql/bin/mysql"
mysql_con="${mysql_bin} -uxxxx -pxxxx"

#log err
keep_log="/tmp/keepalived_script.log"

i=0
interval=5
retrytime=3

$mysql_con -e "show slave status\G;" > /tmp/mysql_slave_status.txt
If_Slave_IO_Running=$(grep -w Slave_IO_Running /tmp/mysql_slave_status.txt|awk  '{print $2}')
If_Slave_SQL_Running=$(grep -w Slave_SQL_Running /tmp/mysql_slave_status.txt|awk  '{print $2}')
Master_Log_File=$(grep -w Master_Log_File /tmp/mysql_slave_status.txt|awk  '{print $2}')
Read_Master_Log_Pos=$(grep -w Read_Master_Log_Pos /tmp/mysql_slave_status.txt|awk  '{print $2}')
Relay_Master_Log_File=$(grep -w Relay_Master_Log_File /tmp/mysql_slave_status.txt|awk  '{print $2}')
Exec_Master_Log_Pos=$(grep -w Exec_Master_Log_Pos /tmp/mysql_slave_status.txt|awk  '{print $2}')

while [ $i -lt ${retrytime} ]
do
        
        #if [[  ${If_Slave_IO_Running} != 'Yes' || ${If_Slave_SQL_Running} != 'Yes' || ${Master_Log_File} != ${Relay_Master_Log_File} || ${Read_Master_Log_Pos} != ${Exec_Master_Log_Pos} ]]

        if [[ ${Master_Log_File} != ${Relay_Master_Log_File} || ${Read_Master_Log_Pos} != ${Exec_Master_Log_Pos} ]]
        then
                echo "$(date) 主从数据不同步，${interval}秒后再检查一次。"
                sleep ${interval}
                ((i++))
                if [ $i -ge ${retrytime} ]
                then
                        echo "$(date) 主从数据不同步，请人工确认是否需要将数据库备库变为主库。"
                        exit 2
                fi
        else 
                break
        fi
done


echo "$(date) 主从数据同步完成，自动切换备库为主库。" >> ${keep_log}

$mysql_con -e 'STOP SLAVE;'
$mysql_con -e 'SET GLOBAL read_only=0;'
$mysql_con -e 'SET GLOBAL event_scheduler=1;'

#
echo "$(date) 主节点运行，停用slave，取消只读模式" >>${keep_log}





