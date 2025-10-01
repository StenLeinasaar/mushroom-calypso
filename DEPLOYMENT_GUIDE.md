# FastNews - Quick Deployment Guide

## 🚀 One-Command Setup

```bash
cd scripts && ./setup.sh
```

That's it! The script will handle everything automatically.

## 📋 What the Setup Script Does

1. ✅ Checks if minikube is running (starts it if needed)
2. ✅ Enables Traefik ingress addon
3. ✅ Configures Docker to use minikube's daemon
4. ✅ Builds backend Docker image
5. ✅ Builds frontend Docker image
6. ✅ Deploys PostgreSQL database
7. ✅ Deploys backend API
8. ✅ Deploys frontend application
9. ✅ Configures Traefik ingress routes
10. ✅ Provides /etc/hosts configuration instructions

## 🌐 DNS Configuration (Required)

After running the setup script, add these entries to `/etc/hosts`:

```bash
# Get minikube IP
MINIKUBE_IP=$(minikube ip)

# Add to /etc/hosts
echo "$MINIKUBE_IP fastnews.local api.fastnews.local" | sudo tee -a /etc/hosts
```

## 🎯 Access the Application

Once deployed and DNS is configured:

- **Frontend**: http://fastnews.local
- **Backend API**: http://api.fastnews.local/api/articles
- **Health Check**: http://api.fastnews.local/health

## 🔍 Verify Deployment

```bash
# Check all pods are running
kubectl get pods -n fastnews

# Expected output:
# NAME                        READY   STATUS    RESTARTS   AGE
# backend-xxxxxxxxxx-xxxxx    1/1     Running   0          2m
# backend-xxxxxxxxxx-xxxxx    1/1     Running   0          2m
# frontend-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
# frontend-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
# postgres-0                  1/1     Running   0          3m

# Check services
kubectl get svc -n fastnews

# Check ingress routes
kubectl get ingressroute -n fastnews
```

## 🐛 Troubleshooting

### Pods not starting?

```bash
# Check pod status
kubectl describe pod <pod-name> -n fastnews

# View logs
kubectl logs <pod-name> -n fastnews
```

### Can't access the website?

1. Verify minikube tunnel is running (if using LoadBalancer)
2. Check `/etc/hosts` entries are correct
3. Verify ingress is working: `kubectl get ingressroute -n fastnews`
4. Check Traefik addon: `minikube addons list | grep ingress`

### Database connection issues?

```bash
# Check database is running
kubectl logs statefulset/postgres -n fastnews

# Verify backend can connect
kubectl logs deployment/backend -n fastnews
```

## 🔄 Update Application

### Update Backend

```bash
eval $(minikube docker-env)
cd backend
docker build -t fastnews-backend:latest .
kubectl rollout restart deployment/backend -n fastnews
```

### Update Frontend

```bash
eval $(minikube docker-env)
cd frontend
docker build -t fastnews-frontend:latest .
kubectl rollout restart deployment/frontend -n fastnews
```

## 🧹 Clean Up

### Remove application but keep minikube

```bash
kubectl delete namespace fastnews
```

### Stop minikube

```bash
minikube stop
```

### Complete cleanup

```bash
kubectl delete namespace fastnews
minikube delete
sudo sed -i '/fastnews.local/d' /etc/hosts
```

## ⏱️ Expected Deployment Time

- **Minikube start**: 1-2 minutes (if not running)
- **Docker builds**: 2-3 minutes (backend + frontend)
- **Kubernetes deployment**: 2-3 minutes (waiting for all pods)
- **Total**: ~5-10 minutes

## 📊 Resource Usage

Minikube will use approximately:
- **CPU**: 2-4 cores
- **Memory**: 2-4 GB
- **Disk**: 1-2 GB (images + storage)

## 🎓 What You'll See

1. **Home Page** (fastnews.local):
   - Grid of 8 article cards
   - Each card shows title, description, author, date, and image
   - Hover effect on cards

2. **Article Detail** (click any card):
   - Full article content
   - Author and publication date
   - Back button to return to list

3. **Backend API** (api.fastnews.local):
   - JSON responses
   - RESTful endpoints
   - Health check endpoints

## 🎉 Success Indicators

✅ All pods show `Running` status  
✅ Services are accessible via domain names  
✅ Frontend loads with 8 article cards  
✅ Clicking an article shows full content  
✅ Backend API returns JSON data  

## 📞 Need Help?

Check these files for more information:
- `README.md` - Full documentation
- `IMPLEMENTATION_SUMMARY.md` - What was built
- `plan.md` - Original project plan

---

**Ready to deploy?** Run `cd scripts && ./setup.sh` and you're good to go! 🚀 