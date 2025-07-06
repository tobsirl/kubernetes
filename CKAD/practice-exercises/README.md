# CKAD Exericises

## Create a namespace called 'mynamespace' and a pod with image nginx called nginx on this namespace

```bash
kubectl create namespace mynamespace
kubectl run nginx --image=nginx --restart=Never -n mynamespace
```

## Create a pod that was just described using YAML

```bash
kubectl run nginx --image=nginx --restart=Never --dry-run=client -n mynamespace -o yaml > pod.yaml

cat pod.yaml

kubectl apply -f pod.yaml -n mynamespace
```

## Create a busybox pod (using kubectl command) that runs the command "env". Run it and see the output

```bash
kubectl run busybox --image=busybox --restart=Never --command -it --rm -- env

kubectl run busybox --image=busybox --command --restart=Never -- env

kubectl logs busybox
```

## Get the YAML for a new namespace called 'myns' without creating it

```bash
kubectl create namespace myns --dry-run=client -o yaml
```

## Create a busybox pod (using YAML) that runs the command "env". Run it and see the output

```bash
kubectl run busybox --image=busybox --restart=Never --command --dry-run=client -- env -o yaml > envpod.yaml
cat envpod.yaml
kubectl apply -f envpod.yaml
kubectl logs busybox
```

## Get the YAML for a new ResourceQuota called 'myrq' with hard limits of 1 CPU, 1G memory and 2 pods without creating it

```bash
kubectl create resourcequota myrq --hard=cpu=1,memory=1Gi,pods=2 --dry-run=client -o yaml
```

## Get pods on all namespaces

```bash
kubectl get pods --all-namespaces
kubectl get pods -A
```

## Create a pod with image nginx called nginx and expose traffic on port 80

```bash
kubectl run nginx --image=nginx --restart=Never --port=80
kubectl expose pod nginx --port=80 --target-port=80 --type=NodePort
kubectl get svc nginx
```

## Change pod's image to nginx:1.7.1. Observe that the container will be restarted as soon as the image gets pulled

Note: The RESTARTS column should contain 0 initially (ideally - it could be any number)

```bash
# Note: The RESTARTS column should contain 0 initially (ideally - it could be any number)
kubectl set image pod/nginx nginx=nginx:1.7.1
kubectl get pods nginx
kubectl describe pod nginx # you will see an event "Container will be killed and re-created" in the events section
kubectl get pod nginx -w # Watch it
# Note: some time after changing the image, you should see that the value in the RESTARTS column has been increased by 1, because the container has been restarted, as stated in the events shown at the bottom of the kubectl describe pod command:

# Note: you can check pod's image by running:
kubectl get pod nginx -o jsonpath='{.spec.containers[].image}{"\n"}'
```

## Get nginx pod's ip created in previous step, use a temp busybox image to wget its '/'

```bash
kubectl get po -o wide # get the IP, will be something like '10.1.1.131'
# create a temp busybox pod
kubectl run busybox --image=busybox --rm -it --restart=Never -- wget -O- 10.1.1.131:80
```
