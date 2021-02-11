#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 kube-system"
    exit 1
else
    kubectl get ns $1 >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
        echo "namespapce '$1' is not exist."
        exit 1
    else

cat << EOF | kubectl apply -f - -n $1
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dev-role
rules:
  - apiGroups:
      - ""
      - "apps"
      - "batch"
      - "extensions"
      - "autoscaling"
    resources:
      - "configmaps"
      - "cronjobs"
      - "deployments"
      - "daemonsets"
      - "statefulsets"
      - "replicationcontrollers"
      - "replicasets"
      - "horizontalpodautoscalers"
      - "events"
      - "ingresses"
      - "jobs"
      - "pods"
      - "pods/attach"
      - "pods/exec"
      - "pods/log"
      - "pods/portforward"
      - "secrets"
      - "services"
      - "replicationcontroller"
    verbs:
      - "create"
      - "delete"
      - "describe"
      - "get"
      - "list"
      - "patch"
      - "update"
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dev-role-binding
subjects:
- kind: User
  name: dev-user
roleRef:
  kind: Role
  name: dev-role
  apiGroup: rbac.authorization.k8s.io
EOF

    fi
fi
