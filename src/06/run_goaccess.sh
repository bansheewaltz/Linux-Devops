#!/bin/bash

### terminal output
# goaccess -a ../04/logs/*.log --log-format=COMBINED

### static HTML output
# goaccess -a ../04/logs/*.log -o report.html --log-format=COMBINED

### Real-Time HTML Output at localhost:80/report.html
service nginx start
goaccess -a ../04/logs/*.log -o /var/www/html/report.html --log-format=COMBINED --real-time-html
