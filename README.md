## 📌 Overview
This repository contains the Terraform configuration for a fully automated, 3-tier web architecture on AWS. Designed for a production environment, it focuses on **high availability**, **scalability**, and **security**.

### 🛠️ Key Features
* **Zero-Downtime Architecture:** Distributed across multiple Availability Zones (AZ-1a & AZ-1b).
* **Security-First Networking:** Instances reside in private subnets with no direct internet access.
* **Least Privilege Access:** Port 8080 is only accessible via the ALB Security Group; SSH is restricted to Bastion Hosts.
* **Self-Healing & Elastic:** Auto Scaling Group (ASG) maintains a desired capacity of 5 instances and scales based on CPU demand.

## 🏗️ Technical Architecture

### 1. Networking (VPC & Routing)
* **VPC:** 10.0.0.0/16 with 4 subnets (2 Public, 2 Private).
* **Connectivity:** NAT Gateways in each public subnet allow private instances to download updates/code without being exposed.

### 2. Compute & Automation
* **Bastion Host:** Provides a secure tunnel for administrative SSH access.
* **Apache2 Bootstrapping:** Launch Templates use `user_data` to install Apache, reconfigure the listener to Port 8080, and pull the latest web content from GitHub.

## 🚀 Deployment Guide

### Prerequisites
* AWS CLI configured with appropriate permissions.
* Terraform v1.0+ installed.
* Fill the remote backend file

### Execution
1. **Initialize:** `terraform init`
2. **Plan:** `terraform plan`
3. **Deploy:** `terraform apply -auto-approve`

---
## 👨‍💻 About Me
**Syed Shakir** * Bachelor of Information Technology (Batch Topper), University of Kashmir.
* DevOps & Cloud Engineering Enthusiast.
* Recently organized the Drone Technology Bootcamp at NIELIT Srinagar.
* **Project Goal:** Optimizing AWS costs and automating scalable infrastructure.
