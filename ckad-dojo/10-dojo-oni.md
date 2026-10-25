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

## Question 2 | Fix a Broken Ingress (6 points)

### Solution

```bash
Inspect the Service:

kubectl get svc frontend-svc -n bastion
# NAME           TYPE        CLUSTER-IP     PORT(S)   AGE
# frontend-svc   ClusterIP   10.96.x.x     80/TCP    ...
Inspect the broken Ingress:

kubectl get ingress frontend-ingress -n bastion -o yaml
The problems are:

Service name is frontend instead of frontend-svc
Port is 8080 instead of 80
pathType is missing
Fix the Ingress:

kubectl edit ingress frontend-ingress -n bastion
Corrected spec:

spec:
  rules:
  - host: frontend.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-svc
            port:
              number: 80
```

## Question 3 | Create a New Ingress (5 points)

### Solution

```bash
kubectl create ingress api-ingress \
  --rule="api.example.com/app=api-svc:80" \
  --annotation="nginx.ingress.kubernetes.io/rewrite-target=/" \
  -n citadel
Or YAML:

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: citadel
spec:
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 80
kubectl apply -f api-ingress.yaml
```

## Question 4 | NetworkPolicy — Label Pods for Communication (6 points)

### Solution

```bash
Inspect the NetworkPolicies:

kubectl describe networkpolicy -n rampart
The policies use these selectors:

allow-frontend-to-backend: ingress on port 80 to pods with tier=backend, from pods with tier=frontend
allow-backend-to-db: ingress on port 5432 to pods with tier=database, from pods with tier=backend
default-deny: denies all ingress by default
Label the pods:

kubectl label pod frontend tier=frontend -n rampart
kubectl label pod backend tier=backend -n rampart
kubectl label pod database tier=database -n rampart
Verify:

kubectl get pods -n rampart --show-labels
```

## Question 5 | Resource Requests and Limits (5 points)

### Solution

```bash
kubectl set resources deployment compute-app -n tower \
  --requests=cpu=100m,memory=128Mi \
  --limits=cpu=200m,memory=256Mi
Or edit directly:

kubectl edit deployment compute-app -n tower
Add under the container spec:

resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"
Verify:

kubectl get pods -n tower
kubectl get deployment compute-app -n tower -o jsonpath='{.spec.template.spec.containers[0].resources}'
```
