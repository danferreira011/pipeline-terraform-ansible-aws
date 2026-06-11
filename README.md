# 🚀 Automated Infrastructure Deployment with Terraform + Ansible + GitHub Actions (AWS)

Projeto DevOps focado em **Infrastructure as Code (IaC)** e **automação de provisionamento e configuração de servidores**, utilizando **Terraform**, **Ansible**, **GitHub Actions** e **AWS**.

O objetivo deste projeto é automatizar todo o fluxo de deploy:

GitHub Actions
        ↓
Terraform
        ↓
AWS EC2 Provisioning
        ↓
Terraform Output
        ↓
Dynamic Inventory Generation
        ↓
Ansible
        ↓
Nginx Installation
        ↓
Custom Website Deployment
        ↓
Automatic URL Output

---

# 📌 Project Overview

Este projeto provisiona automaticamente uma ou mais instâncias EC2 na AWS utilizando Terraform e, após a criação da infraestrutura, configura automaticamente o servidor utilizando Ansible.

Ao final da execução da pipeline, uma página customizada é implantada no **Nginx** e a URL da aplicação é exibida automaticamente no log do workflow.

---

# 🏗️ Architecture

┌────────────────────┐
│   GitHub Actions   │
│   CI/CD Pipeline   │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│     Terraform      │
│ Infrastructure IaC │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│       AWS EC2      │
│  Ubuntu Instance   │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│ Terraform Outputs  │
│ Dynamic Inventory  │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│      Ansible       │
│ Server Config Mgmt │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│       Nginx        │
│ Custom HTML Page   │
└────────────────────┘

---

# ⚙️ Technologies Used

- **Terraform**
- **Ansible**
- **GitHub Actions**
- **AWS EC2**
- **AWS S3 Backend**
- **AWS DynamoDB Locking**
- **Nginx**
- **Ubuntu Server**
- **Bash / Linux**

---

# ✨ Features

✅ AWS EC2 provisioning with Terraform  
✅ Terraform Remote State using **S3 Backend**  
✅ Terraform State Locking with **DynamoDB**  
✅ Dynamic Ansible inventory generation from Terraform outputs  
✅ SSH automation using GitHub Secrets  
✅ Automated Nginx installation with Ansible  
✅ Automated custom HTML deployment  
✅ Automatic infrastructure validation  
✅ Automatic application URL output in CI/CD logs  
✅ Scalable architecture for multiple EC2 instances

---

# 📂 Project Structure

.
├── .github/
│   └── workflows/
│       └── main.yml
│
├── terraform/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
│
├── ansible/
│   ├── inventory/
│   │   └── hosts
│   │
│   ├── playbooks/
│   │   └── nginx.yaml
│   │
│   └── template/
│       └── index.html.j2
│
└── README.md

---

# 🔄 CI/CD Workflow

The pipeline performs the following steps:

### 1. Terraform Initialization

terraform init

### 2. Infrastructure Validation

terraform validate

### 3. Infrastructure Planning

terraform plan

### 4. AWS Infrastructure Provisioning

terraform apply

### 5. Dynamic Inventory Generation

Terraform outputs are converted automatically into an Ansible inventory file.

Example generated inventory:

[webserver]
54.xxx.xxx.xxx ansible_user=ubuntu

### 6. SSH Key Configuration

SSH private key is securely retrieved from **GitHub Secrets**.

### 7. Connectivity Validation

ansible webserver -m ping

### 8. Nginx Installation

Automated using Ansible playbooks.

### 9. Custom Web Page Deployment

Custom HTML page is automatically deployed to:

/var/www/html/index.html

### 10. Application Validation

The workflow validates the deployment by performing:

curl -I http://<public-ip>

---

# 🔐 Terraform Remote State

The project uses:

### S3 Backend

For persistent Terraform state storage.

### DynamoDB Locking

To prevent state corruption during concurrent executions.

Example:

terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

---

# 🔑 Required GitHub Secrets

Configure the following repository secrets:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |
| `SSH_PRIVATE_KEY` | EC2 private SSH key |

---

# 🖥️ Example Deployment Result

At the end of the pipeline:

====================================
Deployment successful!
Application URL(s):
====================================

http://54.xxx.xxx.xxx

And a custom Nginx page becomes available.

---

# 🧠 Technical Challenges Solved

During development, several real-world DevOps challenges were addressed:

- Terraform state loss in ephemeral GitHub runners
- Remote state implementation using S3 backend
- State locking with DynamoDB
- Dynamic inventory generation for Ansible
- SSH host verification issues
- YAML indentation debugging
- Path resolution issues in Ansible templates
- Automated service validation

---

# 🚀 Future Improvements

- HTTPS with Let's Encrypt
- Custom domain integration
- Dockerized deployment
- Auto Scaling Group
- Load Balancer
- Blue/Green Deployment
- Monitoring with Prometheus + Grafana
- Canary Deployment with Argo Rollouts

---

# 👨‍💻 Author

**Danilo Ferreira**

DevOps | Cloud | Infrastructure Automation | CI/CD
---

# ⭐ If you liked this project

Feel free to star the repository and connect with me.