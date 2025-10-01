#!/bin/bash

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.1.7/manifests/install.yaml




kubectl get pods -n argocd
kubectl  -n argocd wait --for=condition=available --timeout=600s deployment/argocd-server
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo >> ./argo-admin-pass.txt


kubectl patch deployment argocd-server -n argocd \
--type='json' \
-p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--insecure"}]'


kubectl  -n argocd wait --for=condition=available --timeout=600s deployment/argocd-server

kubectl port-forward svc/argocd-server -n argocd 8080:443
