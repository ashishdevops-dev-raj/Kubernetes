# Kubernetes Cluster Setup Guide (Ubuntu)

## Prerequisites

- 🖥️ Minimum 2 Ubuntu virtual machines (1 Control Plane node and 1 or more Worker nodes)  
- 💡 Recommended VM size: Standard_B2s or higher  
- 🌐 Networking: All nodes must reside in the same Virtual Network (VNet) and subnet  
- 🔓 Required open ports on the Control Plane node:  
  - TCP 6443 (Kubernetes API server)  
  - TCP 2379-2380 (etcd server client API)  
  - TCP 10250-10252 (Kubelet and controller manager)  
  - TCP 10255 (Read-only Kubelet API)  
- 🔑 SSH access configured for all nodes  
- 🌍 Public IP address for the Control Plane node (optional but recommended)  
- 🔕 Swap must be disabled on all nodes  

---

## Step 1: Prepare Your System (Execute on All Nodes)

```bash
sudo apt update && sudo apt upgrade -y

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo modprobe br_netfilter

# Set sysctl params for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

```

## Step 2: Install Container Runtime (containerd)

```bash
sudo apt install -y containerd

# Generate default config and update cgroup driver
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

```

## Step 3: Install Kubernetes Components (Execute on All Nodes)

```bash
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl

# Add Kubernetes GPG key
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

# Add Kubernetes repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Prevent auto-update
sudo apt-mark hold kubelet kubeadm kubectl


```

## Step 4: Initialize Control Plane Node (Master Node Only)

```bash
# Replace YOUR_CONTROL_PLANE_IP with actual IP
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# After initialization:
  # Copy the kubeadm join command displayed — you will use this on worker nodes.


# Configure kubectl for your user:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


```

## Step 5: Install Pod Network (Calico Example)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

```

## Step 6: Join Worker Nodes

```bash
sudo kubeadm join 192.168.56.2:6443 --token abcdef.0123456789abcdef \ --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

```

## Step 7: Verify Cluster Status (Control Plane Node)

```bash
kubectl get nodes
kubectl get pods -A

```

## Optional Cleanup (Reset Cluster)

```bash
sudo kubeadm reset -f
sudo rm -rf ~/.kube
sudo apt purge kubeadm kubectl kubelet containerd -y
sudo apt autoremove -y

```



