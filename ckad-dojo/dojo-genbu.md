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

## Question 3 | Blue-Green Deployment

### Solution

```yaml
# Step 1: Create the green deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stable-green
  namespace: stripe
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: green
  template:
    metadata:
      labels:
        app: web-app
        version: green
    spec:
      containers:
      - name: nginx
        image: nginx:1.22
        ports:
        - containerPort: 80
EOF

# Step 2: Wait for green pods to be ready
kubectl rollout status deployment/stable-green -n stripe

# Step 3: Switch the service to green
kubectl patch service web-service -n stripe -p '{"spec":{"selector":{"version":"green"}}}'

# Verify
kubectl get endpoints web-service -n stripe
```

## Question 4 | CronJob Advanced

### Solution

```yaml
# Suspend the CronJob first
kubectl patch cronjob data-sync -n prowl -p '{"spec":{"suspend":true}}'

# Add startingDeadlineSeconds and concurrencyPolicy
kubectl patch cronjob data-sync -n prowl -p '{
  "spec": {
    "startingDeadlineSeconds": 200,
    "concurrencyPolicy": "Forbid"
  }
}'

# Resume the CronJob
kubectl patch cronjob data-sync -n prowl -p '{"spec":{"suspend":false}}'

# Verify
kubectl get cronjob data-sync -n prowl -o yaml | grep -E "suspend|startingDeadline|concurrency"
```

### Explanation:

- suspend: true pauses scheduling without deleting the CronJob
- startingDeadlineSeconds: sets a deadline for starting jobs if missed
- concurrencyPolicy: Forbid prevents concurrent job executions

## Question 5 | Immutable ConfigMap

### Solution

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: locked-config
  namespace: hunt
data:
  DB_HOST: postgres.hunt.svc
  DB_PORT: "5432"
  LOG_LEVEL: info
immutable: true
EOF

# Try to modify (should fail)
# kubectl patch configmap locked-config -n hunt -p '{"data":{"LOG_LEVEL":"debug"}}'
# Error: ConfigMap is immutable
```

### Explanation: Immutable ConfigMaps cannot be modified after creation. This improves cluster performance (no watches needed) and prevents accidental changes. To update, delete and recreate.
