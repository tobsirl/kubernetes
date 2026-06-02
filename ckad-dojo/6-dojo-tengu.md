## Question 1 | Namespace and Pod Creation (4 points)

### Solution:

```bash
# Create namespace
kubectl create namespace mynamespace

# Create pod
kubectl run nginx --image=nginx:1.25 --restart=Never -n mynamespace

apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: mynamespace
spec:
  containers:
  - name: nginx
    image: nginx:1.25
  restartPolicy: Never
```

## Question 2 | Pod with Environment Variables (5 points)

### Solution:

```bash
kubectl run envpod --image=busybox:1.36 --restart=Never -n summit --env=VAR1=value1 -- env

apiVersion: v1
kind: Pod
metadata:
  name: envpod
  namespace: summit
spec:
  containers:
  - name: envpod
    image: busybox:1.36
    command: ["env"]
    env:
    - name: VAR1
      value: "value1"
  restartPolicy: Never
```

## Question 3 | ResourceQuota (6 points)

### Solution:

```bash
kubectl create quota cliff-quota -n cliff --hard=cpu=1,memory=1G,pods=2

apiVersion: v1
kind: ResourceQuota
metadata:
  name: cliff-quota
  namespace: cliff
spec:
  hard:
    cpu: "1"
    memory: 1G
    pods: "2"
```

## Question 4 | Labels and Selectors (5 points)

### Solutions

```bash
# Create 3 pods with label app=v1
kubectl run nginx1 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1
kubectl run nginx2 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1
kubectl run nginx3 --image=nginx:1.25 --restart=Never -n ridge --labels=app=v1

# Change nginx2 label to app=v2
kubectl label po nginx2 -n ridge app=v2 --overwrite

# Add tier=web to pods with app=v1
kubectl label po -n ridge -l app=v1 tier=web
```

## Question 5 | Deployment Creation (6 points)

### Solution

```bash
kubectl create deployment nginx-deploy --image=nginx:1.18.0 --replicas=2 --port=80 -n valley

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: valley
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18.0
        ports:
        - containerPort: 80
```

## Question 6 | Deployment Rollout (5 points)

### Solution

```bash
# Update image
kubectl set image deployment/nginx-deploy nginx=nginx:1.19.8 -n valley

# Verify rollout
kubectl rollout status deployment/nginx-deploy -n valley

# Check history
kubectl rollout history deployment/nginx-deploy -n valley
```

## Question 7 | Deployment Rollback (5 points)

### Solution

```bash
# Check rollout status (will show it's failing)
kubectl rollout status deployment/rollback-deploy -n cave

# Rollback to previous revision
kubectl rollout undo deployment/rollback-deploy -n cave

# Verify pods are running
kubectl get pods -n cave -l app=rollback-deploy
```

## Question 8 | Job with Completions (5 points)

### Solution

```bash
kubectl create job echo-job --image=busybox:1.36 -n stone --dry-run=client -o yaml -- /bin/sh -c 'echo hello; sleep 5; echo world' > job.yaml

apiVersion: batch/v1
kind: Job
metadata:
  name: echo-job
  namespace: stone
spec:
  completions: 5
  template:
    spec:
      containers:
      - name: echo-job
        image: busybox:1.36
        command: ["/bin/sh", "-c", "echo hello; sleep 5; echo world"]
      restartPolicy: Never

kubectl apply -f job.yaml
```
