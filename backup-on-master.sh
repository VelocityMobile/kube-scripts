#!/bin/bash

set -ex

rm -f resourceList.txt
rm -f backup-cluster-specific.yaml

echo Listing all daemonsets...
kubectl get daemonsets -o name > daemonsets.txt
echo Listing all configmaps...
kubectl get configmaps -o name | grep -v 'curator-config' > configmaps.txt
echo Listing all services...
kubectl get services -o name | grep -v 'curator-cron' | grep -v 'kubernetes' > services.txt
echo Listing all deployments...
kubectl get deployments -o name | grep -v 'curator-cron' > deployments.txt
echo Listing all secrets...
kubectl get secrets -o name > secrets.txt

echo Backing up all the listed configs
cat daemonsets.txt | xargs -I '%' -n 1 bash -c '(>&2 echo "%"); kubectl get % -o yaml --export; echo ---;' > daemonsets-cluster-specific.yaml
cat configmaps.txt | xargs -I '%' -n 1 bash -c '(>&2 echo "%"); kubectl get % -o yaml --export; echo ---;' > configmaps-cluster-specific.yaml
cat services.txt | xargs -I '%' -n 1 bash -c '(>&2 echo "%"); kubectl get % -o yaml --export; echo ---;' > services-cluster-specific.yaml
cat deployments.txt | xargs -I '%' -n 1 bash -c '(>&2 echo "%"); kubectl get % -o yaml --export; echo ---;' > deployments-cluster-specific.yaml
cat secrets.txt | xargs -I '%' -n 1 bash -c '(>&2 echo "%"); kubectl get % -o yaml --export; echo ---;' > secrets-cluster-specific.yaml

echo Done! 👍
