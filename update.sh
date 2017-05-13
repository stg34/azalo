#!/bin/sh


dump_date=`date "+%Y.%m.%d-%H.%M.%S"`

password='1234567890'

#mysqldump -u root --password=$password redmine > /opt/dumps/redmine.$dump_date.sql
#mysqldump -u root --password=$password trgenl_dev > /opt/dumps/azalo.$dump_date.sql

#tar -cf /opt/dumps/azalo.src.$dump_date.tar ./

hg pull ssh://boris@stgteam.dp.ua:10222/programs/sites/stg/tr_gen_light
hg up

ps ax | grep ruby | grep 3000
#azalo_pid=`ps ax | grep ruby | grep 3000 | cut -f 1 -d ' '`

#kill -INT $azalo_pid

#nohup ruby script/server -e production -p 3000 &