#!/bin/bash

# /etc/init.d/redis-server start

#QUEUE=mailer rake environment resque:work RAILS_ENV=development
RAILS_ENV=production QUEUE=mailer nohup rake environment resque:work &
