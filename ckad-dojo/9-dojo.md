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
