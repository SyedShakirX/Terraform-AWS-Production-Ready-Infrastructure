## 📌 Overview
This repository contains the Terraform configuration for a fully automated, 3-tier web architecture on AWS. Designed for a production environment, it focuses on **high availability**, **scalability**, and **security**.

### 🛠️ Key Features
* **Zero-Downtime Architecture:** Distributed across multiple Availability Zones (AZ-1a & AZ-1b).
* **Security-First Networking:** Instances reside in private subnets with no direct internet access.
* **Least Privilege Access:** Port 8080 is only accessible via the ALB Security Group; SSH is restricted to Bastion Hosts.
* **Self-Healing & Elastic:** Auto Scaling Group (ASG) maintains a desired capacity of 5 instances and scales based on CPU demand.
