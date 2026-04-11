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

## Question 6 | Projected Volume

### Solution

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: config-aggregator
  namespace: hunt
spec:
  serviceAccountName: hunt-sa
  containers:
  - name: aggregator
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: combined-config
      mountPath: /etc/config
  volumes:
  - name: combined-config
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
      - configMap:
          name: app-config
EOF
```

### Explanation: Projected volumes combine multiple sources into a single volume mount. This allows mounting a ServiceAccount token with custom expiration alongside a ConfigMap in the same directory.

## Question 7 | PodDisruptionBudget

### Solution

```yaml
kubectl apply -f - <<EOF
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-pdb
  namespace: jungle
spec:
  minAvailable: 3
  selector:
    matchLabels:
      app: critical-app
EOF

# Verify
kubectl get pdb critical-pdb -n jungle
```

### Explanation: PodDisruptionBudgets protect applications during voluntary disruptions (node drains, cluster upgrades). With minAvailable: 3 on a 5-replica deployment, only 2 pods can be evicted at a time.

## Question 8 | Service ExternalName

### Solution

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: external-api
  namespace: fang
spec:
  type: ExternalName
  externalName: api.external-service.com
EOF

# Test DNS resolution from a pod
# nslookup external-api.fang.svc.cluster.local
```

### Explanation: ExternalName services create CNAME DNS records pointing to external hostnames. No proxying occurs - it's purely DNS aliasing. Useful for referencing external services with internal names.

## Question 9 | LimitRange

### Solution

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
  namespace: pounce
spec:
  limits:
  - type: Container
    default:
      cpu: "500m"
      memory: "256Mi"
    defaultRequest:
      cpu: "100m"
      memory: "64Mi"
    min:
      cpu: "50m"
      memory: "32Mi"
    max:
      cpu: "1"
      memory: "512Mi"
EOF

# Verify
kubectl describe limitrange container-limits -n pounce
```

### Explanation: LimitRanges enforce resource constraints at namespace level. Containers without explicit resources get defaults. Min/max prevent over or under-provisioning.
