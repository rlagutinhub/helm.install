#!/bin/bash
# ----------------------------------------------------------------------------------------------------
# NAME:    K8S.HELM.INSTALL.SH
# DESC:    K8S HELM INSTALL (UNINSTALL)
# DATE:    23.12.2018
# LANG:    BASH
# AUTOR:   LAGUTIN R.A.
# CONTACT: RLAGUTIN@MTA4.RU
# ----------------------------------------------------------------------------------------------------

# https://docs.helm.sh/using_helm/#installing-helm

# https://docs.helm.sh/using_helm/#installing-tiller
function helmins() {
    # kubectl -n kube-system create serviceaccount tiller
    # kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    # kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
    # helm init --service-account tiller --upgrade
    kubectl -n kube-system create serviceaccount tiller
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account=tiller --upgrade
}

# https://docs.helm.sh/using_helm/#deleting-or-reinstalling-tiller
function helmdel() {
    # helm reset
    kubectl -n kube-system delete deployment tiller-deploy
    kubectl -n kube-system delete service tiller-deploy
    kubectl delete clusterrolebinding tiller
    kubectl -n kube-system delete serviceaccount tiller
}

if [ "$1" != "exec" ]; then
    echo 'Usage: '$0' exec [helmins|helmdel|version]'; exit 0
fi

which helm >/dev/null 2>&1

if [ $? -ne 0 ]; then 

    echo "Helm not found."
    echo
    echo "quick setup:"
    echo "    mkdir -p ~/helm-setup; cd ~/helm-setup"
    echo "    wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.1-linux-amd64.tar.gz"
    echo "    mkdir -p ~/helm-setup; tar xvzfp helm-v2.12.1-linux-amd64.tar.gz -C ~/helm-setup/"
    echo "    cp -p ~/helm-setup/linux-amd64/helm /usr/local/bin/"
    exit 1

fi

if [ "$2" == "helmins" ]; then helmins; fi
if [ "$2" == "helmdel" ]; then helmdel; fi
if [ "$2" == "version" ]; then helm version; fi
