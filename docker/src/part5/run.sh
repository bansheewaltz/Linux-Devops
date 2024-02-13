#!/bin/bash

service nginx start
gcc miniserver.c -o miniserver -lfcgi
spawn-fcgi -p 81 -- miniserver
