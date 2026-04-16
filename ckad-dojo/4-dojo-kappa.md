## Question 1 | Secret from Hardcoded Variables (4 points)

### Solution

```bash
# Step 1: Create the Secret
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASS=Secret123! \
  -n stream

# Step 2: Update Deployment to use Secret
kubectl edit deploy api-server -n stream
```

```yaml
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
```

```bash
# Verify
kubectl rollout status deploy api-server -n stream
kubectl get secret db-credentials -n stream
```
