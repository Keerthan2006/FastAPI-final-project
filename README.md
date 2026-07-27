# Three-Tier Kubernetes Web Application (FastAPI + React + PostgreSQL)

This repository contains a full-stack, three-tier web application deployed on **Kubernetes (Minikube)**. It consists of a **React Frontend**, a **FastAPI Backend**, and a **PostgreSQL Database**.

---

## 🔑 Default Superuser Credentials

* **Email:** `admin@example.com`
* **Password:** `Admin@12345`

---

## 🚀 1. How to Access the Application (Browser)

### Option A: Unified URL via Minikube Ingress (Recommended)
All services (Frontend, API, and Documentation) are exposed under **one single URL/IP address**:

* **Minikube Ingress IP:** `http://192.168.49.2`

| Service | Browser URL | Description |
| :--- | :--- | :--- |
| **Frontend Web UI** | `http://192.168.49.2/` | React Single Page Application |
| **Swagger API Docs** | `http://192.168.49.2/docs` | Interactive OpenAPI documentation |
| **ReDoc API Docs** | `http://192.168.49.2/redoc` | Clean API documentation |
| **Backend API** | `http://192.168.49.2/api/v1/` | FastAPI backend endpoints |

#### Optional: Set up a Custom Domain Name (`http://internship.local`)
Add this line to your `/etc/hosts` file (`sudo nano /etc/hosts`):
```text
192.168.49.2  internship.local
```
Now access the web app directly at **`http://internship.local`**!

---

### Option B: Access via Port-Forwarding
If you want direct local access to individual pod services:

* **Frontend UI (Port 8080):**
  ```bash
  kubectl port-forward svc/frontend-service 8080:80 -n internship-app
  ```
  *URL:* `http://localhost:8080`

* **Backend API Docs (Port 8000):**
  ```bash
  kubectl port-forward svc/backend-service 8000:8000 -n internship-app
  ```
  *URL:* `http://localhost:8000/docs`

---

## 🗄️ 2. How to Connect to the PostgreSQL Database

### Method A: Execute Quick SQL Queries from Terminal
Run SQL commands directly against the database inside the PostgreSQL pod:

* **View all created Items:**
  ```bash
  kubectl exec -n internship-app deployment/postgres-deployment -- psql -U postgres -d app -c "SELECT * FROM item;"
  ```

* **View all registered Users:**
  ```bash
  kubectl exec -n internship-app deployment/postgres-deployment -- psql -U postgres -d app -c "SELECT * FROM \"user\";"
  ```

---

### Method B: Open Interactive PostgreSQL Shell (`psql`)
Connect to the interactive PostgreSQL terminal:

```bash
kubectl exec -it -n internship-app deployment/postgres-deployment -- psql -U postgres -d app
```

#### Handy `psql` Commands:
> **Note:** All SQL statements in `psql` must end with a semicolon (`;`).

* `\dt` — List all database tables
* `SELECT * FROM item;` — View all items
* `SELECT * FROM "user";` — View all users
* `\q` — Exit `psql` shell

---

### Method C: Connect via Local Database GUI Client (DBeaver, TablePlus, pgAdmin)
1. Forward the PostgreSQL port to your local machine:
   ```bash
   kubectl port-forward svc/db-service 5432:5432 -n internship-app
   ```
2. Connect using your local DB GUI client:
   * **Host:** `localhost` (or `127.0.0.1`)
   * **Port:** `5432`
   * **Database Name:** `app`
   * **Username:** `postgres`
   * **Password:** `postgres`

---

## 🛠️ 3. Useful Kubernetes Operations & Troubleshooting

* **Check Status of All Pods:**
  ```bash
  kubectl get pods -n internship-app
  ```

* **View Backend Pod Logs:**
  ```bash
  kubectl logs -n internship-app deployment/backend-deployment -f
  ```

* **View Frontend Nginx Proxy Logs:**
  ```bash
  kubectl logs -n internship-app deployment/frontend-deployment -f
  ```

* **Launch Kubernetes Web Dashboard UI:**
  ```bash
  minikube dashboard
  ```
