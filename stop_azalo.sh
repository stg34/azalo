#!/bin/sh


#killall -INT ruby
ps ax | grep ruby
ps ax | grep ruby | grep 400 | sed -e"s/^ *//g" | cut -f 1 -d" " |  tr "\n" " "
kill -INT $(ps ax | grep ruby | grep 400 | sed -e"s/^ *//g" | cut -f 1 -d" " |  tr "\n" " ")

#killall rake
#export VVERBOSE=1; export QUEUE=mailer; nohup rake environment resque:work & > /dev/null

exit 0

