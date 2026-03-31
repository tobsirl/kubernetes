## Question 1 | Pod with Anti-Affinity

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: titan-alpha
  namespace: zeus
  labels:
    app: titan
spec:
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector:
              matchLabels:
                app: titan
            topologyKey: kubernetes.io/hostname
  containers:
    - name: nginx
      image: nginx:1.21
```
