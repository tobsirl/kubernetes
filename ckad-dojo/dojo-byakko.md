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
