#!/bin/bash


aws eks update-kubeconfig --name my-cluster

flux bootstrap github \
	--owner=$GITHUB_USER\
	--repository=onboarding-tasks-pipeline\
	--branch=fluxcd\
	--path=app-cluster\
	--personal

flux create source helm helm-chart --url https://juan-bolivar.github.io/onboarding-tasks-pipeline \ 
	--interval 1m0s\
	--export > helmrepo.yaml

kubectl apply -f helmrepo.yaml --cluster=$(aws eks describe-cluster --name my-cluster | jq -r .cluster.arn)

flux create helmrelease helm-chart \
	--source=HelmRepository/helm-chart
	--chart helm-chart\
	--target-namespace default \
	--interval 3m0s \
	--export > helmrelease.yaml

kubectl apply -f helmrelease.yaml --cluster=$(aws eks describe-cluster --name my-cluster | jq -r .cluster.arn)
