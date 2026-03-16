# Questions Exam 1

## Question 1 | API Resources

### Solution:

```
# List all API resources and save to file

kubectl api-resources > ./exam/course/1/api-resources
```

### Explanation: The kubectl api-resources command lists all available API resources in the cluster, including their shortnames, API group, and whether they are namespaced. This is useful for discovering what resources are available.

## Question 2 | Deployment Recreate Strategy

### Solution:

```yaml
# Create the deployment with Recreate strategy
cat <<EOF > ./exam/course/2/fire-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fire-app
  namespace: blaze
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: fire-app
  template:
    metadata:
      labels:
        app: fire-app
    spec:
      containers:
      - name: fire-container
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF

kubectl apply -f ./exam/course/2/fire-app.yaml
```

### Explanation: The Recreate strategy terminates all existing pods before creating new ones. This is useful when you can't have multiple versions running simultaneously (unlike RollingUpdate which maintains availability during updates).

## Question 3 | Job with Timeout

### Solution:

```yaml
# Copy template and modify
cp ./exam/course/3/job.yaml ./exam/course/3/job.yaml.bak

# Edit the job to add activeDeadlineSeconds
cat <<EOF > ./exam/course/3/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
  namespace: spark
spec:
  activeDeadlineSeconds: 60
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: processor
        image: busybox:1.36
        command: ["sh", "-c", "echo 'Processing data...' && sleep 30 && echo 'Done'"]
      restartPolicy: Never
EOF

kubectl apply -f ./exam/course/3/job.yaml
```

### Explanation: activeDeadlineSeconds sets the maximum duration for a Job. If the Job runs longer than this, it will be terminated. This prevents runaway jobs from consuming resources indefinitely.

## Question 4 | Helm Template Debug

### Solution:

```bash
# Get the values from the installed release and render templates
helm get values phoenix-web -n flare -o yaml > /tmp/phoenix-values.yaml
helm template phoenix-web bitnami/nginx -n flare -f /tmp/phoenix-values.yaml > ./exam/course/4/rendered.yaml

# Alternative: use helm get manifest for already installed release
helm get manifest phoenix-web -n flare > ./exam/course/4/rendered.yaml
```

### Explanation: helm template renders chart templates locally without installing. helm get manifest retrieves the rendered manifests from an installed release. Both are useful for debugging Helm deployments.
