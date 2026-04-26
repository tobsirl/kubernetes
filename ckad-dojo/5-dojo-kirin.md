## Question 1 | ResourceQuota (5 points) See Notes on ResourceQuota

### Solution

```bash
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-limits
  namespace: shell
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 4Gi
    limits.cpu: "8"
    limits.memory: 8Gi
    configmaps: "10"
    secrets: "10"

kubectl apply -f resourcequota.yaml
kubectl describe quota namespace-limits -n shell
```
