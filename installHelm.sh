#!/bin/bash

echo "Installing Helm via install script: https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"

echo "Downloading Helm install script..."
wget https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /dev/null 2>&1

chmod +x ./get-helm-3

echo "Running Helm install script..."
./get-helm-3
