#!/bin/bash

kubectl get nodes
kubectl create -f test-pod.json
kubectl get pods
