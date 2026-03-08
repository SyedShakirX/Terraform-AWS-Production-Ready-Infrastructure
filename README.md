# 🚀 Enterprise-Grade AWS Web Architecture via Terraform

> A fully automated, production-ready, and highly available web application infrastructure deployed on AWS using Terraform. 

This project provisions a robust 3-tier-style architecture featuring strict network segmentation, dynamic Auto Scaling, Application Load Balancing, and complete infrastructure-as-code (IaC) modularity.



## 🏗️ Architecture Overview

The infrastructure is designed to handle web traffic securely and efficiently across multiple Availability Zones. 

1. **User Traffic:** Users access the application via the Application Load Balancer (ALB) public DNS over the internet.
2. **Traffic Routing:** The ALB, residing in Public Subnets, acts as a reverse proxy, forwarding requests on Port 80 to the backend Target Group on Port 8080.
3. **Compute Layer:** The backend consists of an Auto Scaling Group (ASG) of EC2 instances residing entirely in **Private Subnets**. These instances have no direct internet access.
4. **Outbound Connectivity:** The private instances fetch updates and application code (via GitHub) through highly available **NAT Gateways** deployed in the public subnets.
5. **Secure Administration:** A **Bastion Host** (Jump Server) is provisioned in the public subnet, providing the only SSH access path to the private application servers.

---

## ✨ Why is this Production-Ready?

This architecture goes beyond a simple deployment. It implements enterprise best practices across four key pillars:

### 🧩 1. Highly Modular (Infrastructure as Code)
The Terraform codebase is structured into reusable, logically separated modules (e.g., Networking, Compute, Load Balancing). 
* **Maintainability:** Changes to the compute layer do not require touching the networking code.
* **Reusability:** The modules accept variables, allowing the same code to spin up `Dev`, `Staging`, and `Prod` environments by simply changing the `terraform.tfvars` file.
* **State Management:** Ready to be adapted for remote state backends (like S3 + S3 state locking).

### 🌍 2. Highly Available (Fault Tolerant)
The system is built to survive data center failures.
* **Multi-AZ Deployment:** Subnets, NAT Gateways, and the Application Load Balancer are distributed across two Availability Zones (`ap-south-1a` and `ap-south-1b`).
* **Redundant NATs:** If one AZ goes down, the instances in the other AZ retain internet egress capabilities.
* **Self-Healing:** The ALB continuously performs Health Checks on Port 8080. If an instance fails, the ALB stops routing traffic to it, and the ASG automatically terminates and replaces it.

### 🔒 3. Highly Secure (Zero-Trust & Least Privilege)
Security is baked into the network layer using strict Micro-segmentation.
* **Network Isolation:** Application servers live in Private Subnets with no Public IPs. They cannot be reached directly from the internet.
* **Security Group "Chain of Trust":**
  * **ALB SG:** Allows inbound `HTTP/HTTPS` from the world `0.0.0.0/0`.
  * **App Server SG:** Rejects all traffic *except* Port 8080 specifically originating from the ALB Security Group ID, and Port 22 from the Bastion Host SG ID.
* **No Hardcoded Secrets:** Dynamic Key Pairs and Terraform variables ensure no sensitive credentials are leaked in the source code.

### 📈 4. Highly Scalable (Dynamic Elasticity)
The compute layer dynamically adapts to user demand to optimize cost and performance.
* **Auto Scaling Group:** Configured with a minimum of 4, a desired capacity of 5, and a maximum of 8 instances.
* **Target Tracking CPU Policy:** Terraform provisions a CloudWatch metric alarm. If the average CPU utilization of the cluster exceeds **50%**, the ASG automatically spins up new instances. When traffic subsides, it scales back down to save costs.
* **Zero-Touch Provisioning:** Instances boot using a custom Launch Template and an automated `user_data` bash script that installs Apache, configures custom ports, and pulls the latest raw HTML/App code directly from GitHub before joining the Load Balancer.

---

## 🛠️ Technology Stack
* **Cloud Provider:** Amazon Web Services (AWS)
* **IaC Tool:** Terraform
* **Compute:** EC2, Auto Scaling Groups, Launch Templates
* **Networking:** VPC, IGW, NAT Gateways, Route Tables
* **Load Balancing:** Application Load Balancer (ALB), Target Groups
* **Configuration:** Bash (User Data scripts), GitHub Raw URLs

---

## 🚀 How to Deploy

### Prerequisites
* Terraform installed (`>= 1.0.0`)
* AWS CLI configured with appropriate IAM permissions

### Steps to Run

1. **Clone the repository**
   ```bash
   git clone [https://github.com/SyedShakirX/Terraform-AWS-Production-Ready-Infrastructure.git]

 2. **Initialize Terraform**
Downloads the necessary AWS provider plugins.

Bash
terraform init

3. **Review the Deployment Plan**
Verifies the resources that will be created without making actual changes.

Bash
terraform plan

4. **Apply the Infrastructure**
Provisions the AWS resources. Type yes when prompted.

Bash
terraform apply

5. **Access the Application**
Once the deployment is complete, Terraform will output the ALB DNS name. Wait 3-5 minutes for the EC2 health checks to pass, then paste the URL into your browser!

# 🚀 Enterprise-Grade AWS Web Architecture via Terraform

> A fully automated, production-ready, and highly available web application infrastructure deployed on AWS using Terraform. 

This project provisions a robust 3-tier-style architecture featuring strict network segmentation, dynamic Auto Scaling, Application Load Balancing, and complete infrastructure-as-code (IaC) modularity.



## 🏗️ Architecture Overview

The infrastructure is designed to handle web traffic securely and efficiently across multiple Availability Zones. 

1. **User Traffic:** Users access the application via the Application Load Balancer (ALB) public DNS over the internet.
2. **Traffic Routing:** The ALB, residing in Public Subnets, acts as a reverse proxy, forwarding requests on Port 80 to the backend Target Group on Port 8080.
3. **Compute Layer:** The backend consists of an Auto Scaling Group (ASG) of EC2 instances residing entirely in **Private Subnets**. These instances have no direct internet access.
4. **Outbound Connectivity:** The private instances fetch updates and application code (via GitHub) through highly available **NAT Gateways** deployed in the public subnets.
5. **Secure Administration:** A **Bastion Host** (Jump Server) is provisioned in the public subnet, providing the only SSH access path to the private application servers.

---

## ✨ Why is this Production-Ready?

This architecture goes beyond a simple tutorial deployment. It implements enterprise best practices across four key pillars:

### 🧩 1. Highly Modular (Infrastructure as Code)
The Terraform codebase is structured into reusable, logically separated modules (e.g., Networking, Compute, Load Balancing). 
* **Maintainability:** Changes to the compute layer do not require touching the networking code.
* **Reusability:** The modules accept variables, allowing the same code to spin up `Dev`, `Staging`, and `Prod` environments by simply changing the `terraform.tfvars` file.
* **State Management:** Ready to be adapted for remote state backends (like S3 + DynamoDB for state locking).

### 🌍 2. Highly Available (Fault Tolerant)
The system is built to survive data center failures.
* **Multi-AZ Deployment:** Subnets, NAT Gateways, and the Application Load Balancer are distributed across two Availability Zones (`ap-south-1a` and `ap-south-1b`).
* **Redundant NATs:** If one AZ goes down, the instances in the other AZ retain internet egress capabilities.
* **Self-Healing:** The ALB continuously performs Health Checks on Port 8080. If an instance fails, the ALB stops routing traffic to it, and the ASG automatically terminates and replaces it.

### 🔒 3. Highly Secure (Zero-Trust & Least Privilege)
Security is baked into the network layer using strict Micro-segmentation.
* **Network Isolation:** Application servers live in Private Subnets with no Public IPs. They cannot be reached directly from the internet.
* **Security Group "Chain of Trust":**
  * **ALB SG:** Allows inbound `HTTP/HTTPS` from the world `0.0.0.0/0`.
  * **App Server SG:** Rejects all traffic *except* Port 8080 specifically originating from the ALB Security Group ID, and Port 22 from the Bastion Host SG ID.
* **No Hardcoded Secrets:** Dynamic Key Pairs and Terraform variables ensure no sensitive credentials are leaked in the source code.

### 📈 4. Highly Scalable (Dynamic Elasticity)
The compute layer dynamically adapts to user demand to optimize cost and performance.
* **Auto Scaling Group:** Configured with a minimum of 4, a desired capacity of 5, and a maximum of 8 instances.
* **Target Tracking CPU Policy:** Terraform provisions a CloudWatch metric alarm. If the average CPU utilization of the cluster exceeds **50%**, the ASG automatically spins up new instances. When traffic subsides, it scales back down to save costs.
* **Zero-Touch Provisioning:** Instances boot using a custom Launch Template and an automated `user_data` bash script that installs Apache, configures custom ports, and pulls the latest raw HTML/App code directly from GitHub before joining the Load Balancer.

---

## 🛠️ Technology Stack
* **Cloud Provider:** Amazon Web Services (AWS)
* **IaC Tool:** Terraform
* **Compute:** EC2, Auto Scaling Groups, Launch Templates
* **Networking:** VPC, IGW, NAT Gateways, Route Tables
* **Load Balancing:** Application Load Balancer (ALB), Target Groups
* **Configuration:** Bash (User Data scripts), GitHub Raw URLs

---

## 🚀 How to Deploy

### Prerequisites
* Terraform installed (`>= 1.0.0`)
* AWS CLI configured with appropriate IAM permissions

### Steps to Run

1. **Clone the repository**

   ```bash
   git clone https://github.com/YourUsername/Your-Repo-Name.git
   cd Your-Repo-Name
   ```

2. **Initialize Terraform**
   Downloads the necessary AWS provider plugins.

   ```bash
   terraform init
   ```

3. **Review the Deployment Plan**
   Verifies the resources that will be created without making actual changes.

   ```bash
   terraform plan
   ```

4. **Apply the Infrastructure**
   Provisions the AWS resources. Type `yes` when prompted.

   ```bash
   terraform apply
   ```

5. **Access the Application**
   Once the deployment is complete, Terraform will output the **ALB DNS name**.
   Wait **3–5 minutes** for the EC2 health checks to pass, then paste the URL into your browser.

   ```text
   Outputs:
   website_url = "http://shakirs-alb-12345.ap-south-1.elb.amazonaws.com"
   ```

---

### 🧹 Cleanup

To avoid incurring unwanted AWS charges, destroy the infrastructure when you are done testing:

```bash
terraform destroy
```
