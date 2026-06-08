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

## Question 2 | Get Pod IP and Test Connectivity (5 points)

### Solutions

```bash
# Create the Pod
kubectl run web --image=nginx:1.25 --restart=Never -n thicket

# Get the Pod IP and save to file
mkdir -p ./exam/course/2
kubectl get pod web -n thicket -o jsonpath='{.status.podIP}' > ./exam/course/2/pod-ip.txt

# Test connectivity
IP=$(cat ./exam/course/2/pod-ip.txt)
kubectl run busybox --rm -it --restart=Never --image=busybox:1.36 -n thicket -- wget -O- $IP:80
```
