## Question 1 | ResourceQuota (5 points) See Notes on ResourceQuota

### Solution

```bash
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-limits
  namespace: shell
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 4Gi
    limits.cpu: "8"
    limits.memory: 8Gi
    configmaps: "10"
    secrets: "10"

kubectl apply -f resourcequota.yaml
kubectl describe quota namespace-limits -n shell
```

## Question 2 | HorizontalPodAutoscaler (6 points) See Notes on HPA

### Solution

```bash
kubectl autoscale deployment web-app -n ocean \
  --name=web-app-hpa \
  --min=2 \
  --max=10 \
  --cpu=70%

kubectl get hpa -n ocean
```

## Question 3 | StatefulSet (8 points)

### Solution

```bash
apiVersion: v1
kind: Service
metadata:
  name: db-headless
  namespace: reef
spec:
  clusterIP: None
  selector:
    app: db-cluster
  ports:
  - port: 6379
    targetPort: 6379
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db-cluster
  namespace: reef
spec:
  serviceName: db-headless
  replicas: 3
  selector:
    matchLabels:
      app: db-cluster
  template:
    metadata:
      labels:
        app: db-cluster
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 100Mi

kubectl apply -f statefulset.yaml
kubectl get statefulset db-cluster -n reef
kubectl get pods -n reef -l app=db-cluster
```

## Question 4 | DaemonSet (6 points)

### Solution

```bash
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
  namespace: deep
spec:
  selector:
    matchLabels:
      app: node-monitor
  template:
    metadata:
      labels:
        app: node-monitor
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      containers:
      - name: monitor
        image: busybox:1.36
        command: ["sh", "-c", "while true; do echo Node: $NODE_NAME; sleep 60; done"]
        env:
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName

kubectl apply -f daemonset.yaml
kubectl get daemonset node-monitor -n deep
kubectl get pods -n deep -o wide
```

## Question 5 | PriorityClass (5 points)

### Solution

```bash
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: critical-priority
value: 1000000
globalDefault: false
description: "Critical workloads priority"
---
apiVersion: v1
kind: Pod
metadata:
  name: critical-pod
  namespace: tide
spec:
  priorityClassName: critical-priority
  containers:
  - name: nginx
    image: nginx:1.21

kubectl apply -f priorityclass.yaml
kubectl get priorityclass critical-priority
kubectl get pod critical-pod -n tide -o yaml | grep priority
```

## Question 6 | startupProbe (5 points)

### Solution

```bash
apiVersion: v1
kind: Pod
metadata:
  name: slow-starter
  namespace: wave
spec:
  containers:
  - name: app
    image: nginx:1.21
    ports:
    - containerPort: 80
    startupProbe:
      httpGet:
        path: /
        port: 80
      failureThreshold: 30
      periodSeconds: 10
    livenessProbe:
      httpGet:
        path: /
        port: 80

kubectl apply -f slow-starter.yaml
kubectl get pod slow-starter -n wave
kubectl describe pod slow-starter -n wave | grep -A5 "Startup"
```

## Question 7 | Pod Affinity (6 points)

### Solution

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-frontend
  namespace: coral
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-frontend
  template:
    metadata:
      labels:
        app: web-frontend
        tier: frontend
    spec:
      affinity:
        podAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: cache
              topologyKey: kubernetes.io/hostname
      containers:
      - name: frontend
        image: nginx:1.21

kubectl apply -f web-frontend.yaml
kubectl get deployment web-frontend -n coral
kubectl get pods -n coral -o wide
```

## Question 8 | Ingress with Path Routing (6 points)

### Solution

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-routing
  namespace: lagoon
spec:
  ingressClassName: nginx
  rules:
  - host: api.lagoon.local
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: api-v1-svc
            port:
              number: 80
      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80

kubectl apply -f ingress.yaml
kubectl get ingress api-routing -n lagoon
kubectl describe ingress api-routing -n lagoon
```

## Question 9 | Job with Completions and Parallelism (5 points)

### Solution

```bash
apiVersion: batch/v1
kind: Job
metadata:
  name: parallel-processor
  namespace: current
spec:
  completions: 6
  parallelism: 3
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["sh", "-c", "echo Processing batch $RANDOM && sleep 5"]
      restartPolicy: Never

kubectl apply -f job.yaml
kubectl get jobs -n current
kubectl get pods -n current -l job-name=parallel-processor
```

## Question 10 | kubectl debug (4 points)

### Solution

```bash
Using ephemeral containers (K8s 1.25+):

kubectl debug troubled-app -n anchor -it --image=busybox:1.36 --target=app -c debugger -- sh

# Inside the container
ls -la /data > /tmp/output.txt
exit
```

```bash
Alternative using copy-to:

kubectl debug troubled-app -n anchor -it --copy-to=troubled-app-debug --image=busybox:1.36 -- sh
ls -la /data
```

```bash
Save output:

kubectl exec troubled-app -n anchor -- ls -la /data > ./exam/course/10/debug-output.txt
```

## Question 11 | EndpointSlice (3 points)

### Solution

```bash
# List EndpointSlices for the service
kubectl get endpointslices -n shell -l kubernetes.io/service-name=backend-svc

# Get detailed information
kubectl describe endpointslice -n shell -l kubernetes.io/service-name=backend-svc

# Save to file
cat > ./exam/course/11/endpoints-info.txt << 'EOF'
EndpointSlice: backend-svc-xxxxx
Number of endpoints: 3
IP addresses:
  - 10.244.0.10
  - 10.244.0.11
  - 10.244.0.12
Ports: 80/TCP
EOF
```

## Question 12 | Service internalTrafficPolicy (4 points)

### Solution

```bash
kubectl patch service local-svc -n ocean \
  -p '{"spec":{"internalTrafficPolicy":"Local"}}'

kubectl edit svc local-svc -n ocean
# Add: internalTrafficPolicy: Local

Verification:

kubectl get svc local-svc -n ocean -o yaml | grep internalTrafficPolicy
```

## Question 13 | EmptyDir with sizeLimit (4 points)

### Solution

```bash
apiVersion: v1
kind: Pod
metadata:
  name: cache-pod
  namespace: reef
spec:
  containers:
  - name: cache
    image: redis:7-alpine
    volumeMounts:
    - name: cache-volume
      mountPath: /cache
  volumes:
  - name: cache-volume
    emptyDir:
      medium: Memory
      sizeLimit: 100MiapiVersion: v1
kind: Pod
metadata:
  name: cache-pod
  namespace: reef
spec:
  containers:
  - name: cache
    image: redis:7-alpine
    volumeMounts:
    - name: cache-volume
      mountPath: /cache
  volumes:
  - name: cache-volume
    emptyDir:
      medium: Memory
      sizeLimit: 100Mi

kubectl apply -f cache-pod.yaml
kubectl get pod cache-pod -n reef
kubectl describe pod cache-pod -n reef | grep -A5 "Volumes"
```
