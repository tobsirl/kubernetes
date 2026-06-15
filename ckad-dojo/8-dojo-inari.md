# CKAD - Dojo Inari

## Question 1 | Service ClusterIP and Endpoints (5 points)

### Solution

```bash
kubectl run web --image=nginx:1.25 --restart=Never --port=80 --expose -n harvest

Or separately:
kubectl run web --image=nginx:1.25 --restart=Never --port=80 -n harvest
kubectl expose pod web --port=80 -n harvest

Verify:
kubectl get svc web -n harvest
kubectl get ep web -n harvest
```

## Question 2 | Convert Service to NodePort (5 points)

### Solution

```bash
kubectl patch svc app-svc -n grain -p '{"spec":{"type":"NodePort"}}'

Or use edit:
kubectl edit svc app-svc -n grain
# Change spec.type from ClusterIP to NodePort
```

## Question 3 | Deployment with Service (6 points)

### Solution

```bash
# Create Deployment
kubectl create deployment backend --image=nginx:1.25 --replicas=3 --port=8080 -n rice

# Expose Deployment
kubectl expose deployment backend --port=6262 --target-port=8080 -n rice
```

## Question 4 | Readiness Probe HTTP (5 points)

### Solutions

```bash
apiVersion: v1
kind: Pod
metadata:
  name: ready-pod
  namespace: field
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
    readinessProbe:
      httpGet:
        path: /
        port: 80
```

## Question 5 | Liveness Probe with Delay (5 points)

### Solutions

```bash
apiVersion: v1
kind: Pod
metadata:
  name: live-pod
  namespace: shrine
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    livenessProbe:
      exec:
        command:
        - ls
      initialDelaySeconds: 5
      periodSeconds: 10
```
