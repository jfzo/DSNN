#!/bin/bash

nmachines=$1
machine_prefix=$2

nproc=1
for i in $(seq -f "%02g" 1 $nmachines) 
do 
    # for two cpu's per container
    #--cpuset-cpus=$nproc-$((nproc+1))
    # nproc=$((nproc+2))
    echo "sudo docker run --rm -it -d -p 99$i:8888 -p 33$i:22 --cpuset-cpus=$nproc -m 6g -v /home/juan/julia-workspace/:/workspace --hostname $machine_prefix$i -e PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/julia/bin/\" --dns 158.251.4.6 --dns 158.251.4.66  --name=$machine_prefix$i dmlt"
    nproc=$((nproc+1))
done
