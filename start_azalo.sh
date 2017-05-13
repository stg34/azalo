#!/bin/sh


#killall -INT ruby
#ps ax | grep ruby
#ps ax | grep ruby | grep 400 | sed -e"s/^ *//g" | cut -f 1 -d" " |  tr "\n" " "
#kill -INT $(ps ax | grep ruby | grep 400 | sed -e"s/^ *//g" | cut -f 1 -d" " |  tr "\n" " ")


#killall rake
#export VVERBOSE=1; export QUEUE=mailer; nohup rake environment resque:work & > /dev/null

#exit 0

#echo 'sleeping'
#sleep 10

#azalo_path=/opt/azalo
#redmine_path=/opt/redmine

#cd $azalo_path

#nohup ruby script/server -e production -p 4001 > /dev/null &
#nohup ruby script/server -e production -p 4002 > /dev/null &
#nohup ruby script/server -e production -p 4003 > /dev/null &
#nohup ruby script/server -e production -p 4004 > /dev/null &


mongrel_rails cluster::start -C /opt/azalo/config/mongrel_cluster.yml

#nohup ruby script/server -e production -p 4005 > /dev/null &


#cd $redmine_path

#nohup ruby script/server -e production -p 3001 > /dev/null &
#nohup ruby script/server -e production -p 3002 > /dev/null &
#nohup ruby script/server -e production -p 3003 > /dev/null &
