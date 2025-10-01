# ⚡ FastNews - Kubernetes News Application

A modern, cloud-native news application built with React, Node.js, PostgreSQL, and deployed on Kubernetes with Traefik ingress.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Traefik Ingress                    │
│  fastnews.local → Frontend                          │
│  api.fastnews.local → Backend API                   │
└─────────────────────────────────────────────────────┘
                         ↓
        ┌────────────────┴────────────────┐
        ↓                                  ↓
┌──────────────┐                  ┌──────────────┐
│   Frontend   │                  │   Backend    │
│   (React)    │─────────────────→│ (Node.js +   │
│   + Vite     │                  │  Express)    │
└──────────────┘                  └──────────────┘
                                          ↓
                                  ┌──────────────┐
                                  │  PostgreSQL  │
                                  │   Database   │
                                  └──────────────┘
```

## 🚀 Features

- **Modern Frontend**: React 18 with Vite for fast development and optimized builds
- **RESTful API**: Node.js + Express backend with full CRUD operations
- **Persistent Storage**: PostgreSQL database with automatic initialization
- **Cloud-Native**: Kubernetes-ready with health checks, resource limits, and rolling updates
- **Smart Routing**: Traefik ingress with domain-based routing
- **Responsive Design**: Mobile-friendly UI with modern CSS
- **Production-Ready**: Multi-stage Docker builds, nginx static serving, and proper error handling

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (v1.30+)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (v1.28+)
- [Docker](https://docs.docker.com/get-docker/) (v20.10+)
- Bash shell (Linux/macOS) or WSL2 (Windows)

## 🛠️ Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd mushroom-calypso
```

### 2. Run the Setup Script

The setup script will:
- Start minikube (if not running)
- Enable Traefik ingress
- Build Docker images
- Deploy all Kubernetes resources
- Set up local DNS

```bash
cd scripts
./setup.sh
```

### 3. Configure /etc/hosts

After the setup script completes, you'll need to add entries to your `/etc/hosts` file:

```bash
# Get the minikube IP
MINIKUBE_IP=$(minikube ip)

# Add to /etc/hosts (requires sudo)
echo "$MINIKUBE_IP fastnews.local api.fastnews.local" | sudo tee -a /etc/hosts
```

### 4. Access the Application

- **Frontend**: http://fastnews.local
- **Backend API**: http://api.fastnews.local/api/articles

## 📂 Project Structure

```
mushroom-calypso/
├── backend/                  # Node.js Express API
│   ├── src/
│   │   ├── config/          # Database configuration
│   │   ├── models/          # Data models
│   │   ├── routes/          # API routes
│   │   └── index.js         # Application entry point
│   ├── k8s/                 # Kubernetes manifests
│   ├── Dockerfile
│   └── package.json
│
├── frontend/                 # React + Vite application
│   ├── src/
│   │   ├── components/      # React components
│   │   ├── services/        # API client
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── k8s/                 # Kubernetes manifests
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
│
├── database/                 # PostgreSQL configuration
│   ├── init/
│   │   └── init.sql         # Schema and seed data
│   └── k8s/                 # Kubernetes manifests
│
├── k8s/                      # Global Kubernetes resources
│   ├── namespace.yaml
│   └── traefik/
│       └── ingressroute.yaml
│
├── scripts/                  # Deployment scripts
│   ├── setup.sh             # Complete setup
│   ├── deploy.sh            # Deploy to k8s
│   └── hosts-setup.sh       # DNS configuration
│
├── plan.md                   # Detailed project plan
└── README.md                 # This file
```

## 🔧 Manual Deployment

If you prefer to deploy manually:

### 1. Start Minikube and Enable Ingress

```bash
minikube start --driver=docker
minikube addons enable ingress
```

### 2. Use Minikube's Docker Daemon

```bash
eval $(minikube docker-env)
```

### 3. Build Docker Images

```bash
# Build backend
cd backend
docker build -t fastnews-backend:latest .

# Build frontend
cd ../frontend
docker build -t fastnews-frontend:latest .
```

### 4. Deploy to Kubernetes

```bash
cd ../scripts
./deploy.sh
```

## 🎯 API Endpoints

### Articles

- `GET /api/articles` - Get all articles
- `GET /api/articles/:id` - Get single article
- `POST /api/articles` - Create new article
- `PUT /api/articles/:id` - Update article
- `DELETE /api/articles/:id` - Delete article

### Health Checks

- `GET /health` - Application health
- `GET /health/db` - Database connection status

### Example API Request

```bash
# Get all articles
curl http://api.fastnews.local/api/articles

# Get single article
curl http://api.fastnews.local/api/articles/1

# Create article
curl -X POST http://api.fastnews.local/api/articles \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Article",
    "description": "Article description",
    "content": "Article content here...",
    "author": "John Doe",
    "image_url": "https://example.com/image.jpg"
  }'
```

## 📊 Database Schema

```sql
CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  content TEXT NOT NULL,
  author VARCHAR(100),
  image_url TEXT,
  published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🐛 Troubleshooting

### Check Pod Status

```bash
kubectl get pods -n fastnews
```

### View Pod Logs

```bash
# Backend logs
kubectl logs -f deployment/backend -n fastnews

# Frontend logs
kubectl logs -f deployment/frontend -n fastnews

# Database logs
kubectl logs -f statefulset/postgres -n fastnews
```

### Check Services

```bash
kubectl get svc -n fastnews
```

### Check Ingress

```bash
kubectl get ingressroute -n fastnews
```

### Restart Deployment

```bash
kubectl rollout restart deployment/backend -n fastnews
kubectl rollout restart deployment/frontend -n fastnews
```

### Delete and Redeploy

```bash
kubectl delete namespace fastnews
cd scripts
./deploy.sh
```

## 🧹 Cleanup

To remove all resources:

```bash
# Delete the namespace (removes all resources)
kubectl delete namespace fastnews

# Stop minikube (optional)
minikube stop

# Delete minikube cluster (optional)
minikube delete
```

Remove /etc/hosts entries:

```bash
sudo sed -i '/fastnews.local/d' /etc/hosts
```

## 🔄 Development Workflow

### Rebuild and Redeploy Backend

```bash
eval $(minikube docker-env)
cd backend
docker build -t fastnews-backend:latest .
kubectl rollout restart deployment/backend -n fastnews
```

### Rebuild and Redeploy Frontend

```bash
eval $(minikube docker-env)
cd frontend
docker build -t fastnews-frontend:latest .
kubectl rollout restart deployment/frontend -n fastnews
```

## 🎨 Technology Stack

- **Frontend**: React 18, Vite, React Router, Vanilla CSS
- **Backend**: Node.js 20, Express, pg (PostgreSQL client)
- **Database**: PostgreSQL 16
- **Container Runtime**: Docker
- **Orchestration**: Kubernetes (Minikube)
- **Ingress**: Traefik
- **Web Server**: Nginx (for frontend static files)

## 📝 Configuration

### Environment Variables

#### Backend

- `PORT`: Server port (default: 3000)
- `DB_HOST`: PostgreSQL host (default: postgres)
- `DB_PORT`: PostgreSQL port (default: 5432)
- `DB_NAME`: Database name (default: fastnews)
- `DB_USER`: Database user (default: fastnews)
- `DB_PASSWORD`: Database password (default: fastnews123)

#### Frontend

- `VITE_API_URL`: Backend API URL (default: http://api.fastnews.local)

### Resource Limits

| Component  | CPU Request | CPU Limit | Memory Request | Memory Limit |
|------------|-------------|-----------|----------------|--------------|
| Frontend   | 50m         | 200m      | 64Mi           | 128Mi        |
| Backend    | 100m        | 500m      | 128Mi          | 256Mi        |
| PostgreSQL | 250m        | 500m      | 256Mi          | 512Mi        |

## 🚀 Future Enhancements

- [ ] Add authentication and user management
- [ ] Implement article categories and tags
- [ ] Add search functionality
- [ ] Implement pagination
- [ ] Add comments system
- [ ] CI/CD pipeline with GitHub Actions
- [ ] Monitoring with Prometheus and Grafana
- [ ] SSL/TLS with cert-manager
- [ ] Horizontal Pod Autoscaling
- [ ] Helm charts for easier deployment

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

This is a playground environment for learning Kubernetes and cloud-native development. Feel free to experiment and make changes!

## 📧 Support

For questions or issues, please check the troubleshooting section or review the logs.

---

**Built with ❤️ for learning Kubernetes and cloud-native development**
