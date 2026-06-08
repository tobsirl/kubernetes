## Question 1 | Pod with Exposed Port (4 points)

### Solutions

```bash
kubectl run nginx --image=nginx:1.25 --restart=Never --port=80 --expose -n grove
This creates both a Pod and a ClusterIP Service.

Verify:

kubectl get pod nginx -n grove
kubectl get svc nginx -n grove
kubectl get ep nginx -n grove
```
