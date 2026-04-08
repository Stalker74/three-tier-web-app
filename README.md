# 🚀 Secure DevOps Infrastructure on AWS EKS

## 📋 Project Overview

A complete, secure, and scalable DevOps infrastructure for development teams using **Terraform**, **AWS EKS**, and **Jenkins**. All services are accessible only via VPN with **HTTPS** — ensuring a production-grade secure environment.

---

## 🏗️ Architecture Diagram

```
                          ┌─────────────────────────────────────────────────────────────┐
                          │                        AWS Cloud (us-east-1)                 │
                          │                                                               │
                          │   ┌─────────────────────────────────────────────────────┐   │
                          │   │              VPC  (10.0.0.0/16)                      │   │
                          │   │                                                       │   │
                          │   │  ┌──────────────────┐  ┌──────────────────┐         │   │
                          │   │  │  Public Subnet    │  │  Public Subnet   │         │   │
                          │   │  │  us-east-1a       │  │  us-east-1b      │         │   │
                          │   │  │  10.0.101.0/24    │  │  10.0.102.0/24   │         │   │
                          │   │  │  ┌─────────────┐  │  │  ┌───────────┐  │         │   │
                          │   │  │  │  NAT Gateway│  │  │  │ Internet  │  │         │   │
                          │   │  │  └─────────────┘  │  │  │ Gateway   │  │         │   │
                          │   │  └──────────────────┘  │  └───────────┘  │         │   │
                          │   │                         └──────────────────┘         │   │
                          │   │  ┌──────────────────┐  ┌──────────────────┐         │   │
                          │   │  │  Private Subnet   │  │  Private Subnet  │         │   │
                          │   │  │  us-east-1a       │  │  us-east-1b      │         │   │
                          │   │  │  10.0.1.0/24      │  │  10.0.2.0/24     │         │   │
                          │   │  │                   │  │                  │         │   │
                          │   │  │  ┌─────────────┐  │  │ ┌─────────────┐ │         │   │
                          │   │  │  │ EKS Node    │  │  │ │ EKS Node    │ │         │   │
                          │   │  │  │ jenkins-app │  │  │ │ jenkins-    │ │         │   │
                          │   │  │  │ t3.small    │  │  │ │ agents-ng   │ │         │   │
                          │   │  │  │ ┌─────────┐ │  │  │ │ t3.small   │ │         │   │
                          │   │  │  │ │ Jenkins │ │  │  │ │ ┌─────────┐ │ │         │   │
                          │   │  │  │ │  Pod    │ │  │  │ │ │ Jenkins │ │ │         │   │
                          │   │  │  │ └─────────┘ │  │  │ │ │  Agent  │ │ │         │   │
                          │   │  │  │ ┌─────────┐ │  │  │ │ └─────────┘ │ │         │   │
                          │   │  │  │ │  Web    │ │  │  │ └─────────────┘ │         │   │
                          │   │  │  │ │  Pod    │ │  │  └──────────────────┘         │   │
                          │   │  │  │ └─────────┘ │  │                               │   │
                          │   │  │  │ ┌─────────┐ │  │                               │   │
                          │   │  │  │ │  App    │ │  │                               │   │
                          │   │  │  │ └─────────┘ │  │                               │   │
                          │   │  │  │ ┌─────────┐ │  │                               │   │
                          │   │  │  │ │  MySQL  │ │  │                               │   │
                          │   │  │  │ └─────────┘ │  │                               │   │
                          │   │  │  │ ┌─────────┐ │  │                               │   │
                          │   │  │  │ │Prometheus│ │  │                               │   │
                          │   │  │  │ └─────────┘ │  │                               │   │
                          │   │  │  │ ┌─────────┐ │  │                               │   │
                          │   │  │  │ │ Grafana │ │  │                               │   │
                          │   │  │  │ └─────────┘ │  │                               │   │
                          │   │  │  └─────────────┘  │                               │   │
                          │   │  └──────────────────┘                                │   │
                          │   │                                                       │   │
                          │   │  ┌─────────────────────────────────────────────┐     │   │
                          │   │  │        ALB (Internal) 🔒 HTTPS (443)         │     │   │
                          │   │  │  jenkins.volo.pk  |  dev.volo.pk             │     │   │
                          │   │  │  grafana.volo.pk  |  prometheus.volo.pk      │     │   │
                          │   │  └─────────────────────────────────────────────┘     │   │
                          │   └─────────────────────────────────────────────────┘   │   │
                          │                                                           │   │
                          │   ┌──────────┐  ┌──────────┐  ┌──────────────────────┐  │   │
                          │   │   ECR    │  │   IAM    │  │  ACM Certificates    │  │   │
                          │   │ three-   │  │  Roles & │  │  *.volo.pk (HTTPS)   │  │   │
                          │   │ tier-web │  │  Policies│  │  VPN Server + Client │  │   │
                          │   │ three-   │  │  (IRSA)  │  └──────────────────────┘  │   │
                          │   │ tier-app │  └──────────┘                            │   │
                          │   └──────────┘                                          │   │
                          └─────────────────────────────────────────────────────────┘   │
                                                                                         │
Developer Machine ────── VPN (172.16.0.0/22) ──────────────────────────────────────────┘
(AWS VPN Client)
```

---

## 🔧 Infrastructure Components

### Networking (VPC)
| Resource | Value |
|----------|-------|
| VPC CIDR | `10.0.0.0/16` |
| Public Subnets | `10.0.101.0/24`, `10.0.102.0/24` |
| Private Subnets | `10.0.1.0/24`, `10.0.2.0/24` |
| Availability Zones | `us-east-1a`, `us-east-1b` |
| NAT Gateway | Single (Public Subnet) |

### EKS Cluster
| Resource | Value |
|----------|-------|
| Cluster Name | `dev-eks-cluster` |
| Kubernetes Version | `1.30` |
| Node Group 1 | `jenkins-app-ng` — `t3.small` (1-4 nodes) |
| Node Group 2 | `jenkins-agents-ng` — `t3.small` (1-6 nodes) |
| Subnets | Private only |

### VPN
| Resource | Value |
|----------|-------|
| Type | AWS Client VPN |
| Client CIDR | `172.16.0.0/22` |
| Auth | Certificate-based (EasyRSA) |
| Split Tunnel | Enabled |
| Access | Full VPC `10.0.0.0/16` |

### IAM
| Role | Purpose |
|------|---------|
| `eks-cluster-role` | EKS Control Plane |
| `eks-node-role` | Worker Nodes (EKSWorkerNode, CNI, ECR) |
| `jenkins-irsa` | CI/CD — ECR push + EKS describe (OIDC) |
| `alb-controller-irsa` | ALB Ingress Controller (OIDC) |

### ACM Certificates
| Certificate | Purpose |
|-------------|---------|
| `*.volo.pk` | HTTPS for all services (DNS validated via Cloudflare) |
| VPN Server | Client VPN Endpoint authentication |

---

## 📊 Monitoring Stack

| Component | URL | Purpose |
|-----------|-----|---------|
| Prometheus | `https://prometheus.volo.pk` | Metrics collection |
| Grafana | `https://grafana.volo.pk` | Dashboards & Alerts |
| Alertmanager | Internal | Alert routing |
| Slack | `#eks-alerts` | Alert notifications |

### Alert Rules
| Alert | Condition | Channel |
|-------|-----------|---------|
| High CPU Usage | CPU > 80% | Slack `#eks-alerts` |
| High Memory Usage | Memory > 90% | Slack `#eks-alerts` |

---

## ⚙️ CI/CD Pipeline

```
Developer
    │
    ▼
GitHub (PR / Push)
    │
    ▼
Jenkins (https://jenkins.volo.pk)  ◄── VPN + HTTPS Only
    │
    ├── Stage: Build
    │       Jenkins Agent Pod
    │       docker build → three-tier-web / three-tier-app
    │
    ├── Stage: Push
    │       aws ecr get-login-password
    │       docker push → ECR (Git SHA tag)
    │
    └── Stage: Deploy
            kubectl apply → EKS (app namespace)
```

---

## 🌐 Application Architecture (Three-Tier)

```
Browser (VPN Connected)
        │
        ▼
https://dev.volo.pk  🔒 HTTPS
        │
        ▼
ALB Ingress (Internal) ── ALB Ingress Controller
        │
        ▼
┌───────────────┐
│  Web Layer    │  Flask (port 5000)  ← three-tier-web:latest
│  web-service  │  Namespace: app
└───────┬───────┘
        │ http://app-service:4000
        ▼
┌───────────────┐
│  App Layer    │  Flask (port 4000)  ← three-tier-app:latest
│  app-service  │  Namespace: app
└───────┬───────┘
        │ mysql-service:3306
        ▼
┌───────────────┐
│  Data Layer   │  MySQL (port 3306)
│ mysql-service │  PVC: 10Gi gp2-ebs
└───────────────┘
```

---

## 🔒 Security

- All workloads run in **private subnets**
- All services accessible **via VPN only**
- All services use **HTTPS (TLS)** — ACM wildcard `*.volo.pk`
- **HTTP → HTTPS** redirect on all ALBs
- ALB scheme: **internal**
- EKS nodes: **no public IPs**
- VPN auth: **mutual TLS (certificate-based)**
- Jenkins & ALB IAM: **least privilege IRSA (OIDC)**
- DB credentials stored in **Kubernetes Secrets**

---

## 📁 Project Structure

```
EKS Project/
├── terraform/
│   ├── main.tf                  # Root module
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── vpc/                 # VPC, Subnets, NAT, IGW
│       ├── eks/                 # EKS Cluster + Node Groups
│       ├── iam/                 # Roles, Policies, IRSA
│       └── vpn/                 # Client VPN Endpoint
│
├── k8s/
│   ├── jenkins/                 # Jenkins Deployment + Service
│   ├── ingress/                 # Ingress (HTTPS — all services)
│   ├── jenkins-rbac.yaml        # ClusterRole + Binding
│   └── storageclass.yaml        # gp2-ebs StorageClass
│
├── jenkins/
│   ├── Jenkinsfile              # Main pipeline
│   └── agent/
│       └── Dockerfile           # Custom Jenkins Agent
│
└── k8s/app/three-tier-web-app/
    ├── WebLayer/                # Flask Web (port 5000)
    ├── ApplicationLayer/        # Flask App (port 4000)
    ├── k8s/
    │   ├── web-deployment.yaml
    │   ├── app-deployment.yaml
    │   ├── mysql-deployment.yaml
    │   └── ingress.yaml         # dev.volo.pk (HTTPS)
    └── Jenkinsfile              # App CI/CD pipeline
```

---

## 🚀 Deployment Steps

### 1. Infrastructure Deploy
```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

### 2. EKS Access Setup
```bash
aws eks update-kubeconfig --region us-east-1 --name dev-eks-cluster
```

### 3. Kubernetes Resources Apply
```bash
kubectl apply -f k8s/storageclass.yaml
kubectl apply -f k8s/jenkins-rbac.yaml
kubectl apply -f k8s/jenkins/jenkins.yaml
kubectl apply -f k8s/ingress/ingress.yaml
```

### 4. App Deploy
```bash
kubectl create namespace app
kubectl apply -f k8s/app/three-tier-web-app/k8s/
```

### 5. Monitoring Deploy
```bash
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
```

### 6. VPN Connect
```
AWS VPN Client → Load client-config.ovpn → Connect
```

### 7. Access
| Service | URL |
|---------|-----|
| Application | https://dev.volo.pk |
| Jenkins | https://jenkins.volo.pk |
| Grafana | https://grafana.volo.pk |
| Prometheus | https://prometheus.volo.pk |

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| IaC | Terraform |
| Container Orchestration | AWS EKS (Kubernetes 1.30) |
| CI/CD | Jenkins |
| Container Registry | AWS ECR |
| Networking | AWS VPC, Client VPN |
| Load Balancer | AWS ALB (Ingress Controller) |
| Monitoring | Prometheus + Grafana |
| Alerting | Alertmanager + Slack |
| App Framework | Python Flask |
| Database | MySQL |
| Certificates | EasyRSA, AWS ACM (*.volo.pk) |
| DNS | Cloudflare |

---

## ✅ Project Status

| Component | Status |
|-----------|--------|
| VPC + Networking | ✅ Complete |
| EKS Cluster | ✅ Complete |
| Node Groups (x2) | ✅ Complete |
| IAM Roles & Policies (IRSA) | ✅ Complete |
| AWS Client VPN | ✅ Complete |
| ALB Ingress Controller | ✅ Complete |
| HTTPS (ACM *.volo.pk) | ✅ Complete |
| Jenkins Deployment | ✅ Complete |
| Jenkins CI/CD Pipeline | ✅ Complete |
| Three-Tier App | ✅ Complete |
| ECR Repositories | ✅ Complete |
| Prometheus + Grafana | ✅ Complete |
| Slack Alerts (CPU + Memory) | ✅ Complete |
| https://dev.volo.pk | ✅ Complete |
| https://jenkins.volo.pk | ✅ Complete |
| https://grafana.volo.pk | ✅ Complete |
| https://prometheus.volo.pk | ✅ Complete |
