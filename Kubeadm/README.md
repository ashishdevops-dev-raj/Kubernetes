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

# To do above setup, follow below provided steps


# Step 1: Identify or Create a Security Group

1. Log in to the AWS Management Console:
    Go to the EC2 Dashboard.

2. Locate Security Groups:
    In the left menu under Network & Security, click on Security Groups.

3. Create a New Security Group:
    Click on Create Security Group.
    Provide the following details:
           Name: (e.g., Kubernetes-Cluster-SG)
            Description: A brief description for the security group (mandatory)
            VPC: Select the appropriate VPC for your instances (default is acceptable)

4. Add Rules to the Security Group:
    Allow SSH Traffic (Port 22):
        Type: SSH
        Port Range: 22
        Source: 0.0.0.0/0 (Anywhere) or your specific IP

    Allow Kubernetes API Traffic (Port 6443):
        Type: Custom TCP
        Port Range: 6443
        Source: 0.0.0.0/0 (Anywhere) or specific IP ranges

5. Save the Rules:
   Click on Create Security Group to save the settings.


