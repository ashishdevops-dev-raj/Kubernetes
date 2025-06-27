# Kubeadm Installation Guide

This guide outlines the steps needed to set up a Kubernetes cluster using kubeadm.

# Prerequisites

    Ubuntu OS (Xenial or later)
    sudo privileges
    Internet access
    t2.medium instance type or higher

# AWS Setup

1. Ensure that all instances are in the same Security Group.
2. Expose port 6443 in the Security Group to allow worker nodes to join the cluster.
3. Expose port 22 in the Security Group to allows SSH access to manage the instance..
