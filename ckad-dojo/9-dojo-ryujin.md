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

## Question 6 | PersistentVolumeClaim

### Solution

```bash
# Create PVC YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sea-pvc
  namespace: depths
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 2Gi
EOF
```

## Question 7 | Pod with PVC

### Solution

```bash
# Create Pod with PVC mount
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
  namespace: depths
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: data-volume
      mountPath: /data
  volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: sea-pvc
EOF
```

## Question 8 | Pod with nodeName

### Solution

```bash
# Get the first node name
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

# Create Pod with nodeName
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: direct-pod
  namespace: coral
spec:
  nodeName: $NODE
  containers:
  - name: nginx
    image: nginx:1.25
EOF
```
