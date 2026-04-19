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
