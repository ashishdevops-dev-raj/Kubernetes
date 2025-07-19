#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "🚀 Starting Minikube installation on Linux..."

# Step 1: Install kubectl
echo "📦 Installing kubectl..."
sudo apt update
sudo apt install -y apt-transport-https curl gnupg lsb-release

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
  https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
  https://apt.kubernetes.io/ kubernetes-xenial main" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubectl

# Step 2: Install Docker (VM driver)
echo "🐳 Installing Docker..."
sudo apt install -y docker.io
sudo usermod -aG docker $USER

# Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Step 3: Install Minikube
echo "⬇️ Downloading Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Step 4: Start Minikube with Docker driver
echo "🚀 Starting Minikube with Docker..."
minikube start --driver=docker

# Step 5: Test Kubernetes installation
echo "🔍 Verifying Minikube status..."
kubectl get nodes
kubectl get pods -A

# Step 6: Optional - deploy a test app
echo "📦 Deploying test app..."
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-minikube --type=NodePort --port=8080

echo "🌐 Accessing the test app in browser..."
minikube service hello-minikube

echo "✅ Minikube setup complete!"
