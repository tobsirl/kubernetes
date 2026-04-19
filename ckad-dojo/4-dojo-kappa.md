## Question 1 | Secret from Hardcoded Variables (4 points) Hard

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

## Question 2 | CronJob with Schedule and History Limits (8 points)

### Solution

```bash
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
  namespace: pond
spec:
  schedule: "*/30 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      activeDeadlineSeconds: 300
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: backup
              image: busybox:latest
              command: ["/bin/sh", "-c"]
              args: ["echo Backup completed"]
EOF

# Verify
kubectl get cronjob backup-job -n pond
kubectl describe cronjob backup-job -n pond

# Test (optional)
kubectl create job backup-job-test --from=cronjob/backup-job -n pond
kubectl logs job/backup-job-test -n pond
```

## Question 3 | ServiceAccount, Role, and RoleBinding (8 points)

### Solution

```bash
# Step 1: Create ServiceAccount
kubectl create sa log-sa -n marsh

# Step 2: Create Role
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: log-role
  namespace: marsh
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
EOF

# Step 3: Create RoleBinding
kubectl create rolebinding log-rb \
  --role=log-role \
  --serviceaccount=marsh:log-sa \
  -n marsh

# Step 4: Update Pod to use ServiceAccount
kubectl get pod log-collector -n marsh -o yaml > /tmp/log-collector.yaml
# Edit to change serviceAccountName to log-sa
kubectl delete pod log-collector -n marsh
kubectl apply -f /tmp/log-collector.yaml

# Verify
kubectl get pod log-collector -n marsh
kubectl logs log-collector -n marsh
```
