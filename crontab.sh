#!/bin/bash
source ~/.bashrc
#change /home/holin/projects/mongodb-monitor to your path
/home/holin/.rbenv/shims/ruby /home/holin/projects/mongodb-monitor/monitor.rb

#crontab set
#*/2 * * * * /home/holin/projects/mongodb-monitor/crontab.sh  >>  /home/holin/projects/mongodb-monitor/log/crontab.log  2>&1
