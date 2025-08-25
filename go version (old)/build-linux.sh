#!/bin/bash

echo -n "compiling... "
t0=$(date +%s)
# go build -trimpath -ldflags="-s -w" .
CGO_ENABLED=0 go build -trimpath -a -installsuffix cgo -ldflags '-s -w' .

t1=$(date +%s)
let dt=t1-t0
echo "ended in ${dt} seconds"
ls -alph archnewscheck
echo "dependencies:"
ldd ./archnewscheck

echo -n "compression... "
t0=$(date +%s)
upx -9 -q archnewscheck > /dev/null
t1=$(date +%s)
let dt=t1-t0
echo "ended in ${dt} seconds"
ls -alph archnewscheck
