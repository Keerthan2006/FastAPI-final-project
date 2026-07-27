# 🚀 Three-Tier Web Application (FastAPI + React + PostgreSQL)

A production-ready, full-stack three-tier web application built with **FastAPI**, **React (Vite + Nginx)**, and **PostgreSQL**, deployed on **Kubernetes (Minikube)** with automated **DevSecOps CI/CD (GitHub Actions)** and **GitOps Continuous Deployment (Argo CD)**.

---

## 📐 Architecture Overview

```text
[ Browser / Client ]
         │
         ▼
[ Nginx Ingress Controller ]
    │                      │
    ├── / (Frontend)       └── /api & /docs (Backend)
    ▼                          ▼
[ React Frontend Pod ]      [ FastAPI Backend Pod ]
                                   │
                                   ▼
                            [ PostgreSQL DB Pod ]
```

---

## 🛠️ Tech Stack & Tools

* **Frontend:** React 18, TypeScript, Vite, Chakra UI, Nginx
* **Backend:** Python 3.12, FastAPI, SQLModel, Alembic (Migrations), Poetry
* **Database:** PostgreSQL 16
* **Containerization:** Docker, Docker Compose
* **Orchestration:** Kubernetes (Minikube), Nginx Ingress Controller
* **CI/CD Security Pipeline:** GitHub Actions, Gitleaks (Secret Scan), Semgrep (SAST), Trivy (Container Scan)
* **GitOps Continuous Deployment:** Argo CD

---

## 🔑 Initial Superuser Credentials

The application seeds an admin superuser on startup using environment variables configured in `backend/.env`:

| Parameter | Environment Variable | Default Location |
| :--- | :--- | :--- |
| **Admin Email** | `$FIRST_SUPERUSER` | `backend/.env` |
| **Admin Password** | `$FIRST_SUPERUSER_PASSWORD` | `backend/.env` |

---

## 🚀 Quick Start Guide: From Zero to Deployment

### 📋 Prerequisites
Ensure the following tools are installed on your system:
* [Docker](https://docs.docker.com/get-docker/) & [Minikube](https://minikube.sigs.k8s.io/docs/start/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* Git, Python 3.12+, Node.js 20+

---

### Step 1: Environment Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/Keerthan2006/FastAPI-final-project.git
   cd FastAPI-final-project
   ```

2. Verify or create your environment variables in `backend/.env`:
   ```bash
   cat <<EOF > backend/.env
   PROJECT_NAME=Internship Project
   ENVIRONMENT=local
   DOMAIN=localhost
   SECRET_KEY=supersecretkey12345

   POSTGRES_SERVER=db
   POSTGRES_PORT=5432
   POSTGRES_DB=app
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres

   FIRST_SUPERUSER=admin@example.com
   FIRST_SUPERUSER_PASSWORD=Admin@12345
   EOF
   ```

---

### Step 2: Deploy to Kubernetes Cluster (Minikube)

1. **Start Minikube and enable the Ingress addon**:
   ```bash
   minikube start
   minikube addons enable ingress
   ```

2. **Create Kubernetes Secrets from your environment file**:
   ```bash
   bash k8s/create-secret-from-env.sh
   ```

3. **Deploy all application manifests**:
   ```bash
   kubectl apply -f k8s/
   ```

4. **Verify that all pods are running**:
   ```bash
   kubectl get pods -n internship-app
   ```
   *(Expected status: `1/1 Running` for `postgres`, `backend`, and `frontend` pods).*

---

### Step 3: Enable Automated GitOps Deployment (Argo CD)

Argo CD runs inside Kubernetes and automatically keeps your live cluster in sync with changes pushed to GitHub.

1. **Install Argo CD into Minikube**:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. **Apply the Argo CD Application configuration**:
   ```bash
   kubectl apply -f k8s/argocd-application.yaml
   ```

3. **Access Argo CD Web UI**:
   * Forward port:
     ```bash
     kubectl port-forward svc/argocd-server -n argocd 8080:443
     ```
   * Open browser: **`https://localhost:8080`** (Username: `admin`)
   * Get initial password:
     ```bash
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
     ```

---

## 🌐 How to Access the Web Application

### Option 1: Unified Access via Minikube Ingress (Recommended)
Get your Minikube IP address:
```bash
minikube ip
# Example output: 192.168.49.2
```

Navigate to the unified URLs in your web browser:

| Service | URL | Description |
| :--- | :--- | :--- |
| **Frontend Web UI** | `http://192.168.49.2/` | Main React User Interface |
| **Swagger API Docs** | `http://192.168.49.2/docs` | Interactive OpenAPI Documentation |
| **ReDoc API Docs** | `http://192.168.49.2/redoc` | API Technical Reference |
| **Backend REST API** | `http://192.168.49.2/api/v1/` | Application API Endpoints |

#### Optional: Configure Custom Domain (`http://internship.local`)
Add your Minikube IP to your system's `/etc/hosts` file:
```bash
sudo sh -c 'echo "$(minikube ip)  internship.local" >> /etc/hosts'
```
Now access your application cleanly at **`http://internship.local`**!

---

### Option 2: Access via Port-Forwarding (Local Fallback)

* **Frontend UI:**
  ```bash
  kubectl port-forward svc/frontend-service 8080:80 -n internship-app
  ```
  Open **`http://localhost:8080`**

* **Backend API Docs:**
  ```bash
  kubectl port-forward svc/backend-service 8000:8000 -n internship-app
  ```
  Open **`http://localhost:8000/docs`**

---

## 🗄️ Database Management & Queries

### 1. Direct Query via Terminal
Run quick SQL queries directly inside the database pod:

* **List all created items:**
  ```bash
  kubectl exec -n internship-app deployment/postgres-deployment -- psql -U postgres -d app -c "SELECT * FROM item;"
  ```

* **List all registered users:**
  ```bash
  kubectl exec -n internship-app deployment/postgres-deployment -- psql -U postgres -d app -c "SELECT * FROM \"user\";"
  ```

---

### 2. Interactive PostgreSQL Shell (`psql`)
```bash
kubectl exec -it -n internship-app deployment/postgres-deployment -- psql -U postgres -d app
```
* Useful commands inside `psql`:
  * `\dt` — Show all tables
  * `SELECT * FROM item;` — View item data
  * `\q` — Exit shell

---

### 3. GUI Database Client Connection (DBeaver / TablePlus / pgAdmin)
1. Forward PostgreSQL port:
   ```bash
   kubectl port-forward svc/db-service 5432:5432 -n internship-app
   ```
2. Connect using credentials from `backend/.env`:
   * **Host:** `localhost`
   * **Port:** `5432`
   * **Database:** `$POSTGRES_DB` (`app`)
   * **User:** `$POSTGRES_USER` (`postgres`)
   * **Password:** `$POSTGRES_PASSWORD` (`postgres`)

---

## 🛡️ DevSecOps CI/CD Pipeline (GitHub Actions)

When changes are pushed to GitHub, `.github/workflows/ci.yaml` automatically executes:
1. **Secret Scanning:** Gitleaks scans for exposed API keys or tokens.
2. **SAST Analysis:** Semgrep scans application code for static security flaws.
3. **Backend & Frontend Automated Testing:** Runs `pytest` and builds frontend static assets.
4. **Container Security Scan:** Trivy scans Docker images for critical/high vulnerabilities.
5. **Docker Build & Push:** Builds container images tagged with commit SHA and pushes to Docker Hub.
6. **DAST Scanning (OWASP ZAP):** Performs Dynamic Application Security Testing against the live running application to detect XSS, SQLi, CORS, and header misconfigurations.
7. **Argo CD Auto-Sync:** Argo CD detects new git commits and deploys updates to Kubernetes automatically.

---

## 📑 Handy Operations Commands

| Action | Command |
| :--- | :--- |
| **Check All Pods** | `kubectl get pods -n internship-app` |
| **Check Ingress Status** | `kubectl get ingress -n internship-app` |
| **Backend Logs** | `kubectl logs -n internship-app deployment/backend-deployment -f` |
| **Frontend Logs** | `kubectl logs -n internship-app deployment/frontend-deployment -f` |
| **Argo CD Status** | `kubectl get application -n argocd` |
| **Restart Backend** | `kubectl rollout restart deployment/backend-deployment -n internship-app` |
| **Restart Frontend** | `kubectl rollout restart deployment/frontend-deployment -n internship-app` |
| **Minikube Dashboard** | `minikube dashboard` |
