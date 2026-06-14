# CKAD - Dojo Inari

## Question 1 | Service ClusterIP and Endpoints (5 points)

### Solution

```bash
kubectl run web --image=nginx:1.25 --restart=Never --port=80 --expose -n harvest

Or separately:
kubectl run web --image=nginx:1.25 --restart=Never --port=80 -n harvest
kubectl expose pod web --port=80 -n harvest

Verify:
kubectl get svc web -n harvest
kubectl get ep web -n harvest
```

## Question 2 | Convert Service to NodePort (5 points)

### Solution

```bash
kubectl patch svc app-svc -n grain -p '{"spec":{"type":"NodePort"}}'

Or use edit:
kubectl edit svc app-svc -n grain
# Change spec.type from ClusterIP to NodePort
```
