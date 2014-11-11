#!/bin/bash
set -x

# activate logging service
service rsyslog start

# activate myproxy-server service
service myproxy-server start

