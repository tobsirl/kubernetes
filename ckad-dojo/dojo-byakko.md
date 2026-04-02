## Question 1 | Pod with Anti-Affinity

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: titan-alpha
  namespace: zeus
  labels:
    app: titan
spec:
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector:
              matchLabels:
                app: titan
            topologyKey: kubernetes.io/hostname
  containers:
    - name: nginx
      image: nginx:1.21
```

## Question 2 | ConfigMap from Multiple Sources

### Solution

```yaml
# Create ConfigMap with literals
kubectl create configmap app-config -n athena \
  --from-literal=LOG_LEVEL=debug \
  --from-literal=MAX_CONNECTIONS=100

# Create Pod that mounts ConfigMap
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-reader
  namespace: athena
spec:
  containers:
  - name: reader
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
EOF
```

## Question 3 | ExternalName Service

### Solution

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-api
  namespace: hermes
spec:
  type: ExternalName
  externalName: api.external-service.com
```

## Question 4 | LimitRange Configuration

### Solution

```yaml
# LimitRange
apiVersion: v1
kind: LimitRange
metadata:
  name: resource-limits
  namespace: apollo
spec:
  limits:
    - type: Container
      default:
        cpu: 500m
        memory: 256Mi
      defaultRequest:
        cpu: 100m
        memory: 64Mi
---
# Pod (will get defaults from LimitRange)
apiVersion: v1
kind: Pod
metadata:
  name: limited-pod
  namespace: apollo
spec:
  containers:
    - name: app
      image: nginx:1.21
```

## Question 5 | SecurityContext - Read-Only Root Filesystem

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
  namespace: hades
spec:
  containers:
    - name: nginx
      image: nginx:1.21
      securityContext:
        readOnlyRootFilesystem: true
      volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: cache
          mountPath: /var/cache/nginx
        - name: run
          mountPath: /var/run
  volumes:
    - name: tmp
      emptyDir: {}
    - name: cache
      emptyDir: {}
    - name: run
      emptyDir: {}
```
