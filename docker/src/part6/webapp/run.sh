#!/bin/bash

gcc miniserver.c -o miniserver -lfcgi
spawn-fcgi -p 81 -n miniserver
