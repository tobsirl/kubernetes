## Question 1 | Pod with Exposed Port (4 points)

### Solutions

```bash
kubectl run nginx --image=nginx:1.25 --restart=Never --port=80 --expose -n grove
This creates both a Pod and a ClusterIP Service.

Verify:

kubectl get pod nginx -n grove
kubectl get svc nginx -n grove
kubectl get ep nginx -n grove
```

## Question 2 | Get Pod IP and Test Connectivity (5 points)

### Solutions

```bash
# Create the Pod
kubectl run web --image=nginx:1.25 --restart=Never -n thicket

# Get the Pod IP and save to file
mkdir -p ./exam/course/2
kubectl get pod web -n thicket -o jsonpath='{.status.podIP}' > ./exam/course/2/pod-ip.txt

# Test connectivity
IP=$(cat ./exam/course/2/pod-ip.txt)
kubectl run busybox --rm -it --restart=Never --image=busybox:1.36 -n thicket -- wget -O- $IP:80
```

## Question 3 | Pod Logs (4 points)

### Solutions

```bash
# Create the Pod
kubectl run logger --image=busybox:1.36 --restart=Never -n glade -- /bin/sh -c 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done'

# Wait for Pod to start
kubectl wait --for=condition=Ready pod/logger -n glade --timeout=30s

# Save logs (first 10 lines)
mkdir -p ./exam/course/3
kubectl logs logger -n glade | head -10 > ./exam/course/3/logs.txt
```

## Question 4 | Debug Pod with Error (5 points)

### Solutions

```bash
# Create the Pod with error command
kubectl run debug-pod --image=busybox:1.36 --restart=Never -n meadow -- ls /notexist

# Wait a moment for the Pod to complete
sleep 2

# Get logs and save
mkdir -p ./exam/course/4
kubectl logs debug-pod -n meadow > ./exam/course/4/error.txt 2>&1
```

## Question 5 | Pod with Node Selector (6 points)

### Solutions

```bash
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
  namespace: fern
spec:
  nodeSelector:
    accelerator: nvidia
  containers:
  - name: nginx
    image: nginx:1.25


kubectl apply -f gpu-pod.yaml
```

## Question 6 | Pod with Tolerations (6 points)

### Solutions

```bash
apiVersion: v1
kind: Pod
metadata:
  name: tolerate-pod
  namespace: moss
spec:
  containers:
  - name: nginx
    image: nginx:1.25
  tolerations:
  - key: "tier"
    operator: "Equal"
    value: "frontend"
    effect: "NoSchedule"


kubectl apply -f tolerate-pod.yaml
```

## Question 7 | Deployment with Replicas (5 points)

### Solutions

```bark
kubectl create deployment app-deploy --image=nginx:1.18.0 --replicas=3 --port=80 -n root
Or using YAML:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deploy
  namespace: root
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-deploy
  template:
    metadata:
      labels:
        app: app-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.18.0
        ports:
        - containerPort: 80
```

## Question 8 | Scale Deployment (4 points)

### Solutions

```bash
kubectl scale deployment app-deploy --replicas=5 -n root
Verify:

kubectl get deployment app-deploy -n root
kubectl get pods -n root -l app=app-deploy
```

## Question 9 | Horizontal Pod Autoscaler (6 points)

### Solutions

```bash
kubectl autoscale deployment app-deploy --min=5 --max=10 --cpu-percent=80 -n root
Verify:

kubectl get hpa app-deploy -n root
```

## Question 10 | Deployment Rollout Pause and Resume (6 points)

### Solutions

```bash
# Pause the rollout
kubectl rollout pause deployment/pause-deploy -n bark

# Update the image
kubectl set image deployment/pause-deploy nginx=nginx:1.19.0 -n bark

# Check rollout history (no new revision should appear)
kubectl rollout history deployment/pause-deploy -n bark

# Resume the rollout
kubectl rollout resume deployment/pause-deploy -n bark

# Verify the image
kubectl describe deployment pause-deploy -n bark | grep Image
```
