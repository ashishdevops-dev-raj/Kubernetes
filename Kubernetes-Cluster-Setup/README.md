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


## Step 2: Install Container Runtime (containerd)


sudo apt install -y containerd

# Generate default config and update cgroup driver
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd


