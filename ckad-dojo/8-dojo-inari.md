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

## Question 6 | LimitRange for Namespace (6 points)

### Solutions

```bash
apiVersion: v1
kind: LimitRange
metadata:
  name: pod-limits
  namespace: blessing
spec:
  limits:
  - max:
      memory: "500Mi"
    min:
      memory: "100Mi"
    type: Pod
```

## Question 7 | ResourceQuota with Requests and Limits (6 points)

### Solution

```bash
kubectl create quota compute-quota -n fortune \
  --hard=requests.cpu=1,requests.memory=1Gi,limits.cpu=2,limits.memory=2Gi

Or YAML:

apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: fortune
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

## Question 8 | Pod within ResourceQuota (5 points)

### Solution

```bash
apiVersion: v1
kind: Pod
metadata:
  name: quota-pod
  namespace: fortune
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    resources:
      requests:
        cpu: "0.5"
        memory: "512Mi"
      limits:
        cpu: "1"
        memory: "1Gi"
```

## Question 9 | Security Context with Capabilities (6 points)

### Solutions

```bash
apiVersion: v1
kind: Pod
metadata:
  name: cap-pod
  namespace: golden
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - SYS_TIME
```

## Question 10 | Shared Volume Between Containers (6 points)

### Solution

```bash
apiVersion: v1
kind: Pod
metadata:
  name: shared-pod
  namespace: bounty
spec:
  containers:
  - name: writer
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  - name: reader
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  volumes:
  - name: shared-data
    emptyDir: {}
```
