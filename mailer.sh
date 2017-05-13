#!/bin/bash

#QUEUE=mailer rake environment resque:work RAILS_ENV=development
QUEUE=mailer rake environment resque:work
