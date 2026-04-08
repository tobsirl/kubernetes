## Question 1 | kubectl explain

### Solution

```bash
# Navigate the API documentation
kubectl explain pod.spec.containers.resources

# Save to file
kubectl explain pod.spec.containers.resources --recursive > ./exam/course/1/pod-spec-fields.txt
```

### Explanation: kubectl explain provides built-in documentation for Kubernetes API resources. Use dot notation to navigate nested fields. The --recursive flag shows all sub-fields.

## Question 2 | Pod Anti-Affinity

### Solution

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spread-pods
  namespace: tiger
spec:
  replicas: 3
  selector:
    matchLabels:
      app: spread-pods
  template:
    metadata:
      labels:
        app: spread-pods
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - spread-pods
            topologyKey: kubernetes.io/hostname
      containers:
      - name: web
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF
```

## Explanation: Pod anti-affinity with requiredDuringSchedulingIgnoredDuringExecution enforces hard constraints. The topology key kubernetes.io/hostname ensures pods are scheduled on different nodes. If there aren't enough nodes, pods will remain Pending.
