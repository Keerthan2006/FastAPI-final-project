# 🚀 DevSecOps Three-Tier Cloud-Native Application

[![DevSecOps CI Pipeline](https://github.com/Keerthan2006/FastAPI-final-project/actions/workflows/ci.yaml/badge.svg)](https://github.com/Keerthan2006/FastAPI-final-project/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.30+-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Argo CD](https://img.shields.io/badge/GitOps-Argo%20CD-EF7B4D?logo=argo&logoColor=white)](https://argoproj.github.io/cd/)

An enterprise-grade, full-stack **Three-Tier Web Application** built with **FastAPI**, **React**, and **PostgreSQL**. The project showcases an end-to-end **DevSecOps pipeline** incorporating static and dynamic security analysis (Gitleaks, Semgrep, Trivy, OWASP ZAP) and automated **GitOps continuous delivery** using **Argo CD** on **Kubernetes (Minikube)**.

---

## 🎯 Main Project Goal

The primary goal of this project is to demonstrate a production-ready, security-hardened, and scalable web application lifecycle. It bridges modern web development with cloud-native infrastructure and security engineering:

1. **Three-Tier Modular Architecture:** Clear separation of concerns between presentation (React), application logic (FastAPI), and persistent data (PostgreSQL).
2. **DevSecOps Integration:** Security checks embedded directly into the CI/CD pipeline at every stage—from pre-build secret scanning to post-deployment dynamic vulnerability scanning.
3. **Automated GitOps Deployment:** Continuous state synchronization between the git repository and the Kubernetes cluster using Argo CD, eliminating manual cluster deployments.

---

## 📐 System Architecture & Workflow

```text
                               ┌─────────────────────────────────────────────────────────┐
                               │                 DevSecOps CI/CD Pipeline                │
                               │                     (GitHub Actions)                    │
                               └────────────────────────────┬────────────────────────────┘
                                                            │
  ┌─────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┐
  │                                                         │                                                        │
  ▼                                                         ▼                                                        ▼
[ Gitleaks ] ──► [ Semgrep ] ──► [ Pytest / Build ] ──► [ Trivy Scan ] ──► [ Docker Push ] ──► [ OWASP ZAP DAST ] ──► [ Argo CD Sync ]
Secret Scan        SAST Scan       Unit Tests & Build     Container Scan       Docker Hub           Dynamic Scan         GitOps Deploy
                                                                                                                           │
                                                                                                                           │
  ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
  │
  ▼
┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                              Kubernetes Cluster (Minikube)                                             │
│                                                                                                                        │
│   [ Client Browser ]                                                                                                   │
│            │                                                                                                           │
│            ▼                                                                                                           │
│   [ Nginx Ingress Controller ]                                                                                         │
│       │               │                                                                                                │
│       │ /             │ /api & /docs                                                                                   │
│       ▼               ▼                                                                                                │
│   ┌────────┐      ┌────────┐       ┌───────────────────┐      ┌─────────────────────┐                                  │
│   │Frontend│      │Backend │ ──►   │ Alembic Migration │ ──►  │ Initial Data Seeder │                                  │
│   │ (Pod)  │      │ (Pod)  │       │  (Init Container) │      │  (Init Container)   │                                  │
│   └───┬────┘      └───┬────┘       └─────────┬─────────┘      └──────────┬──────────┘                                  │
│       │               │                      │                       │                                         │
│       └───────────────┴──────────────────────┼───────────────────────┘                                         │
│                                              ▼                                                                         │
│                                      [ PostgreSQL DB ]                                                                 │
│                                       (Pod & PVC Data)                                                                 │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🧰 Technology Stack

| Layer | Technologies & Tools |
| :--- | :--- |
| **Frontend Tier** | React 18, TypeScript, Vite, Chakra UI, Nginx (Alpine) |
| **Backend Tier** | Python 3.12, FastAPI, SQLModel, Alembic, Pydantic v2, Uvicorn, Poetry |
| **Database Tier** | PostgreSQL 16 (Alpine) with Persistent Volume Claims (PVC) |
| **Containerization** | Docker, Docker Compose (Multi-stage builds) |
| **Orchestration** | Kubernetes, Nginx Ingress Controller, ConfigMaps & Secrets |
| **DevSecOps Pipeline** | GitHub Actions, Gitleaks, Semgrep, Trivy, OWASP ZAP |
| **GitOps Engine** | Argo CD |

---

## 🔄 End-to-End DevSecOps Pipeline Flow

Every commit or pull request to `main` or `develop` triggers the automated pipeline configured in `.github/workflows/ci.yaml`:

1. **Secret Scanning (Gitleaks):** Scans git history and modified files for accidentally hardcoded secrets, API tokens, or private keys.
2. **SAST Analysis (Semgrep):** Performs Static Application Security Testing to detect code vulnerabilities, unsafe queries, or bad practices.
3. **Backend Testing & Frontend Build:**
   - Spins up an ephemeral PostgreSQL database container.
   - Executes database migrations via Alembic and seeds initial test data.
   - Runs the backend test suite with `pytest`.
   - Compiles and validates the React frontend production bundle using Vite.
4. **Container Vulnerability Scan (Trivy):** Builds Docker images for frontend and backend, scanning them for OS and dependency CVEs.
5. **Registry Publishing:** Pushes verified, tagged container images (`latest` and `${GITHUB_SHA}`) to Docker Hub.
6. **DAST Scanning (OWASP ZAP):** Launches the application stack via Docker Compose and executes dynamic application security tests against `http://localhost:5173` to test for XSS, CORS misconfigurations, and header vulnerabilities.
7. **GitOps Deployment (Argo CD):** Argo CD monitors the `k8s/` directory and synchronizes changes to the Kubernetes cluster automatically.

---

## 🔐 Environment Variables & Security Configuration

> [!IMPORTANT]
> **Never commit real secrets or credentials to version control.** Always populate `.env` locally or inject secrets securely through GitHub Repository Secrets or Kubernetes Secrets.

### Environment File Template (`backend/.env` & `.env`)

Create `backend/.env` (and copy to root `.env` for Docker Compose) using the structure below:

```bash
# Application Configuration
PROJECT_NAME="FastAPI Application"
ENVIRONMENT="local"                     # local, staging, or production
DOMAIN="localhost"
SECRET_KEY="<your-secure-random-32-character-secret-key>"

# PostgreSQL Database Configuration
POSTGRES_SERVER="db"                    # Service name in Docker Compose / K8s
POSTGRES_PORT=5432
POSTGRES_DB="app"
POSTGRES_USER="<your_postgres_username>"
POSTGRES_PASSWORD="<your_postgres_password>"

# Initial Superuser Account Creation
FIRST_SUPERUSER="admin@example.com"
FIRST_SUPERUSER_PASSWORD="<your_strong_admin_password>"
```

---

## 🚀 Getting Started

### 📋 Prerequisites

Make sure the following tools are installed:
- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) & [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Python 3.12+ & Node.js 20+

---

### Option 1: Local Development with Docker Compose

To quickly spin up the entire application stack locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Keerthan2006/FastAPI-final-project.git
   cd FastAPI-final-project
   ```

2. **Create environment files:**
   ```bash
   # Copy the configuration template and update placeholder credentials
   cp backend/.env.example backend/.env 2>/dev/null || touch backend/.env
   # Ensure backend/.env contains your configuration, then copy to root:
   cp backend/.env .env
   ```

3. **Start the application stack:**
   ```bash
   docker compose up -d --build
   ```

4. **Verify container status:**
   ```bash
   docker compose ps
   ```

---

### Option 2: Deploy to Kubernetes Cluster (Minikube)

1. **Start Minikube and enable Ingress:**
   ```bash
   minikube start
   minikube addons enable ingress
   ```

2. **Create Kubernetes Secrets from your environment file:**
   ```bash
   bash k8s/create-secret-from-env.sh
   ```

3. **Apply Kubernetes Manifests:**
   ```bash
   kubectl apply -f k8s/
   ```

4. **Verify Pod Readiness:**
   ```bash
   kubectl get pods -n internship-app
   ```
   *(All pods: `postgres`, `backend`, and `frontend` should show `1/1 Running` status).*

---

### ⚙️ Setting Up GitOps with Argo CD

1. **Install Argo CD on Minikube:**
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. **Apply the Argo CD Application Manifest:**
   ```bash
   kubectl apply -f k8s/argocd-application.yaml
   ```

3. **Access Argo CD Web Dashboard:**
   ```bash
   # Port-forward Argo CD server
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   - Open **`https://localhost:8080`** in your browser.
   - **Username:** `admin`
   - **Get initial password:**
     ```bash
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
     ```

---

## 🌐 Accessing Application Endpoints

### Access via Ingress (Minikube IP)

Retrieve your Minikube IP address:
```bash
minikube ip
# Example: 192.168.49.2
```

Navigate to the unified URLs in your web browser:

| Service | Access URL | Description |
| :--- | :--- | :--- |
| **Frontend Web Application** | `http://<MINIKUBE_IP>/` | React Single Page Application |
| **Swagger Interactive Docs** | `http://<MINIKUBE_IP>/docs` | OpenAPI Endpoint Testing & Specs |
| **ReDoc API Documentation** | `http://<MINIKUBE_IP>/redoc` | Technical API Reference |
| **Backend REST API** | `http://<MINIKUBE_IP>/api/v1/` | Base API Endpoint |

> [!TIP]
> **Optional Custom Domain Mapping:** Add `<MINIKUBE_IP> internship.local` to `/etc/hosts` to access the application via **`http://internship.local`**.

---

## 🛠️ Operations & Troubleshooting Commands

| Task | Command |
| :--- | :--- |
| **View All Pods** | `kubectl get pods -n internship-app` |
| **View Ingress Configuration** | `kubectl get ingress -n internship-app` |
| **Stream Backend Logs** | `kubectl logs -n internship-app deployment/backend-deployment -f` |
| **Stream Frontend Logs** | `kubectl logs -n internship-app deployment/frontend-deployment -f` |
| **Execute SQL Query in DB Pod** | `kubectl exec -it -n internship-app deployment/postgres-deployment -- psql -U postgres -d app` |
| **Restart Backend Service** | `kubectl rollout restart deployment/backend-deployment -n internship-app` |
| **Restart Frontend Service** | `kubectl rollout restart deployment/frontend-deployment -n internship-app` |
| **Check Argo CD App Status** | `kubectl get application -n argocd` |
