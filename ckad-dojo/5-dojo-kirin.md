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
