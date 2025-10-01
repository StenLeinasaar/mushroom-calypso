# FastNews - Kubernetes News Application

## 📋 Architecture Overview

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
│   (React)    │                  │ (Node.js +   │
│   Service    │                  │  Express)    │
└──────────────┘                  └──────────────┘
                                          ↓
                                  ┌──────────────┐
                                  │  PostgreSQL  │
                                  │   Database   │
                                  └──────────────┘
```

## Technology Stack & Rationale

### Database: PostgreSQL
- **Why**: Robust, reliable, excellent for structured data like news articles
- **Deployment**: StatefulSet with PersistentVolume

### Backend: Node.js + Express
- **Why**: Simple, JavaScript ecosystem consistency with frontend, fast development
- **Features**: REST API for CRUD operations on news articles
- **Port**: 3000 internally

### Frontend: React + Vite
- **Why**: Modern, component-based, fast development with Vite
- **Features**: Article cards list view, individual article detail view, routing
- **Port**: 80 internally (nginx serving static build)

### Ingress: Traefik
- **Why**: Kubernetes-native, automatic SSL, great for local development
- **Configuration**: IngressRoute for both domains

### Container Runtime: Docker
- Multi-stage builds for optimized image sizes

## Project Structure

```
mushroom-calypso/
├── backend/
│   ├── Dockerfile              # Multi-stage Node.js build
│   ├── package.json
│   ├── src/
│   │   ├── index.js           # Express app entry
│   │   ├── routes/            # API routes
│   │   ├── models/            # Database models
│   │   └── config/            # DB connection config
│   └── k8s/
│       ├── deployment.yaml
│       └── service.yaml
│
├── frontend/
│   ├── Dockerfile              # Multi-stage React build
│   ├── package.json
│   ├── vite.config.js
│   ├── public/
│   ├── src/
│   │   ├── App.jsx
│   │   ├── components/
│   │   │   ├── ArticleCard.jsx
│   │   │   ├── ArticleList.jsx
│   │   │   └── ArticleDetail.jsx
│   │   └── services/
│   │       └── api.js         # API client
│   └── k8s/
│       ├── deployment.yaml
│       └── service.yaml
│
├── database/
│   ├── init/
│   │   └── init.sql           # Initial schema + seed data
│   └── k8s/
│       ├── statefulset.yaml
│       ├── service.yaml
│       ├── pvc.yaml
│       └── configmap.yaml
│
├── k8s/
│   ├── namespace.yaml          # fastnews namespace
│   ├── traefik/
│   │   ├── helmfile.yaml      # Or manual manifests
│   │   └── ingressroute.yaml  # Routes for both domains
│   └── kustomization.yaml     # Optional: for organized deployment
│
├── scripts/
│   ├── setup.sh               # Complete setup script
│   ├── deploy.sh              # Deploy all services
│   └── hosts-setup.sh         # Add entries to /etc/hosts
│
└── README.md                   # Setup instructions
```

## Implementation Order

### Phase 1: Foundation & Database (Steps 1-3)

#### 1. Project Structure Setup
- Create directory structure
- Initialize Git repository structure
- Create README with setup instructions

#### 2. Database Layer
- Create PostgreSQL schema for news articles table
- Write init.sql with seed data (5-10 sample articles)
- Create Kubernetes manifests (StatefulSet, Service, PVC, ConfigMap)
- Test database deployment independently

#### 3. Kubernetes Namespace & Base Setup
- Create fastnews namespace
- Set up Traefik using Helm or manifests
- Configure DNS (hosts file entries)

### Phase 2: Backend API (Steps 4-5)

#### 4. Backend Application
- Initialize Node.js project with Express
- Create REST API endpoints:
  - `GET /api/articles` - List all articles
  - `GET /api/articles/:id` - Get single article
  - `POST /api/articles` - Create article
  - `PUT /api/articles/:id` - Update article
  - `DELETE /api/articles/:id` - Delete article
- Add PostgreSQL connection using `pg` library
- Add CORS configuration for frontend
- Create Dockerfile with multi-stage build

#### 5. Backend Kubernetes Deployment
- Create Deployment manifest
- Create Service (ClusterIP)
- Add environment variables for DB connection
- Test API locally in cluster

### Phase 3: Frontend (Steps 6-7)

#### 6. Frontend Application
- Initialize React + Vite project
- Create components:
  - `ArticleList`: Grid of article cards
  - `ArticleCard`: Individual card with image, title, preview
  - `ArticleDetail`: Full article view with routing
- Set up React Router for navigation
- Create API service client to call backend
- Style with simple CSS (or Tailwind for cleaner look)
- Create Dockerfile (build + nginx serve)

#### 7. Frontend Kubernetes Deployment
- Create Deployment manifest
- Create Service (ClusterIP)
- Configure API endpoint as environment variable

### Phase 4: Ingress & Integration (Steps 8-9)

#### 8. Traefik Ingress Configuration
- Create IngressRoute for `fastnews.local` → frontend service
- Create IngressRoute for `api.fastnews.local` → backend service
- Configure middleware if needed (CORS, headers)

#### 9. Integration & Testing
- Deploy all services in order: DB → Backend → Frontend → Ingress
- Test full flow: Browse to fastnews.local, view articles, click details
- Verify API calls through api.fastnews.local
- Add scripts for easy deployment and teardown

### Phase 5: Polish & Documentation (Step 10)

#### 10. Final Touches
- Create comprehensive README with:
  - Prerequisites (minikube, kubectl, docker)
  - Setup instructions
  - How to access the application
- Add deployment scripts for one-command setup
- Add sample data seeding
- Document how to add new articles

## Data Model

### Articles Table

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

## Key Design Decisions

1. **Modular Structure**: Each component (frontend, backend, database) is self-contained with its own Dockerfile and k8s manifests
2. **Environment-based Configuration**: Use ConfigMaps and Secrets for environment-specific settings
3. **Simple but Realistic**: No authentication yet, but structure allows easy addition later
4. **Local Development Friendly**: Use minikube's docker daemon, no need for remote registry
5. **Traefik over Nginx Ingress**: Better for local dev, easier SSL, modern tooling

## Development Notes

- Using plain CSS for frontend styling (can upgrade to Tailwind later)
- Minikube-focused deployment (no Docker Compose initially)
- Sample news articles will cover tech topics 