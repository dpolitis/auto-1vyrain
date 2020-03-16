#!/bin/bash
set -e

/usr/bin/python2 -m SimpleHTTPServer 8080&

/usr/bin/livecd-creator --fslabel=1vyrain --cache=/var/cache/live --config=$1
/bin/cp *.iso result/
