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

## Question 2 | Pod with Environment Variables (5 points)

### Solution:

```bash
kubectl run envpod --image=busybox:1.36 --restart=Never -n summit --env=VAR1=value1 -- env

apiVersion: v1
kind: Pod
metadata:
  name: envpod
  namespace: summit
spec:
  containers:
  - name: envpod
    image: busybox:1.36
    command: ["env"]
    env:
    - name: VAR1
      value: "value1"
  restartPolicy: Never
```

## Question 3 | ResourceQuota (6 points)

### Solution:

```bash
kubectl create quota cliff-quota -n cliff --hard=cpu=1,memory=1G,pods=2

apiVersion: v1
kind: ResourceQuota
metadata:
  name: cliff-quota
  namespace: cliff
spec:
  hard:
    cpu: "1"
    memory: 1G
    pods: "2"
```
