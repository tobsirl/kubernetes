## Question 1 | Helm Create Chart

### Solution

```bash
# Create directory if needed
mkdir -p ./exam/course/1

# Create the Helm chart
cd ./exam/course/1
helm create sea-app
```

## Question 2 | Helm Install with Custom Values

### Solution

```bash
# Add bitnami repo if not already added
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install with custom values
helm install my-release bitnami/nginx -n tide --set replicaCount=2
```

## Question 3 | Helm Upgrade Release

### Solution

```bash
# Upgrade the release with new replica count
helm upgrade my-release bitnami/nginx -n tide --set replicaCount=3
```

## Question 4 | Helm Rollback

### Solution

```bash
# Check current revision
helm history rollback-app -n wave

# Rollback to revision 1
helm rollback rollback-app 1 -n wave
```

## Question 5 | PersistentVolume Creation

### Solution

```bash
# Create PersistentVolume YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sea-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /data/sea
EOF
```
