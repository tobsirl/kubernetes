## Question 1 | Secrets & Environment Variables (5 points)

### Solution

```bash
Inspect the existing Pod:

kubectl get pod webapp -n fortress -o yaml | grep -A 10 env
The Pod has DB_USER=admin and DB_PASS=secret123.

Create the Secret:

kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASS=secret123 \
  -n fortress
Delete the existing Pod:

kubectl delete pod webapp -n fortress
Recreate the Pod with secretKeyRef:

apiVersion: v1
kind: Pod
metadata:
  name: webapp
  namespace: fortress
spec:
  containers:
  - name: webapp
    image: nginx:1.25
    ports:
    - containerPort: 80
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_USER
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_PASS
kubectl apply -f webapp-fixed.yaml
```
