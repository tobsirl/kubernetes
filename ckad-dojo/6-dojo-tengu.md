## Question 1 | Namespace and Pod Creation (4 points)

### Solution:

```bash
# Create namespace
kubectl create namespace mynamespace

# Create pod
kubectl run nginx --image=nginx:1.25 --restart=Never -n mynamespace

apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: mynamespace
spec:
  containers:
  - name: nginx
    image: nginx:1.25
  restartPolicy: Never
```
