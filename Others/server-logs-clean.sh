#!/bin/bash
#---- Server Logs File Clear
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete
find /var/log -type f -name "*-*" -delete
find /var/log -type f -exec truncate -s 0 {} \;
