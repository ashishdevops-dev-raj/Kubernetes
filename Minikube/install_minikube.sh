#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

echo "🐳 Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker $USER && newgrp docker

echo "💻 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client

echo "🌱 Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
minikube version

echo "🚀 Starting Minikube with Docker driver..."
minikube start --driver=docker

echo "✅ Installation complete!"
echo "📝 Note: Log out and log back in for Docker group permissions to take effect."
echo "🔧 You can run 'minikube status' and 'kubectl get nodes' to verify setup."
