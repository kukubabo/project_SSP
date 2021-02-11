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

# delete ingress
kubectl -n $1 delete -f 01-7.ingress.yaml

# delete controllers / services
kubectl -n $1 delete rc/redis-master rc/redis-slave rc/guestbook svc/redis-master svc/redis-slave svc/guestbook

    fi
fi
