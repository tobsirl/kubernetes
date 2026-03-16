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
