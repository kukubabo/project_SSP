#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 default"
    exit 1
else
    kubectl get ns $1 >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
        echo "namespapce '$1' is not exist."
        exit 1
    else

# create 'test' namespace
#kubectl create ns test

# create redis controller / service
kubectl -n $1 apply -f 01-1.redis-master-controller.json
kubectl -n $1 apply -f 01-2.redis-master-service.json
kubectl -n $1 apply -f 01-3.redis-slave-controller.json
kubectl -n $1 apply -f 01-4.redis-slave-service.json

# create guestbook controller / service
kubectl -n $1 apply -f 01-5.guestbook-controller.json
kubectl -n $1 apply -f 01-6.guestbook-service.json

# create ingress
kubectl -n $1 apply -f 01-7.ingress.yaml

#echo ""
#echo "##### TEST URL #####"
#echo "http://$INGRESS_SVC"

    fi
fi
