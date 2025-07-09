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

## Get pod's YAML

```bash
kubectl get pod nginx -o yaml
```

## Get information about the pod, including details about potential issues (e.g. pod hasn't started)

```bash
kubectl describe pod nginx
```

## Get pod's logs

```bash
kubectl logs nginx
```

## If the pod crashed and restarted, get the logs of the previous instance

```bash
kubectl logs nginx -p
kubectl logs nginx --previous
```

## Execute a simple shell on the nginx pod

```bash
kubectl exec -it nginx -- /bin/sh
```

## Create a busybox pod that echoes 'hello world' and then exits

```bash
kubectl run busybox --image=busybox --restart=Never --command -- echo "hello world"
kubectl logs busybox
```

## Create a busybox pod that echoes 'hello world' and then exits, but have the pod deleted automatically when it's completed

```bash
kubectl run busybox --image=busybox --restart=Never --command -it --rm -- echo "hello world"
kubectl logs busybox
# Note: you will not be able to get the logs after the pod is deleted
# kubectl logs busybox # will not work, because the pod is deleted
```

## Create an nginx pod and set an env value as 'var1=val1'. Check the env value existence within the pod

```bash
kubectl run nginx --image=nginx --restart=Never --env="var1=val1"
kubectl exec -it nginx -- env   # This will show all environment variables, including 'var1=val1'
kubectl exec -it nginx -- sh -c 'echo $var1'
kubectl describe pod nginx | grep -i env
kubectl run nginx --restart=Never --image=nginx --env=var1=val1 -it --rm -- env
kubectl run nginx --image nginx --restart=Never --env=var1=val1 -it --rm -- sh -c 'echo $var1'
```

## If pod crashed and restarted, get logs about the previous instance

```bash
kubectl logs nginx -p
kubectl logs nginx --previous
```

## Create a Pod with two containers, both with image busybox and command "echo hello; sleep 3600". Connect to the second container and run 'ls'

```bash
kubectl run busybox --image=busybox --restart=Never -o yaml --dry-run=client -- /bin/sh -c 'echo hello;sleep 3600' > pod.yaml vi pod.yaml

Copy/paste the container related values, so your final YAML should contain the following two containers (make sure those containers have a different name):

---
containers:
  - args:
    - /bin/sh
    - -c
    - echo hello;sleep 3600
    image: busybox
    imagePullPolicy: IfNotPresent
    name: busybox
    resources: {}
  - args:
    - /bin/sh
    - -c
    - echo hello;sleep 3600
    image: busybox
    name: busybox2
---

kubectl create -f pod.yaml

# Connect to the busybox2 container within the pod
kubectl exec -it busybox -c busybox2 -- /bin/sh
ls
exit

# or you can do the above with just an one-liner
kubectl exec -it busybox -c busybox2 -- ls
# you can do some cleanup

```

## Get pod logs

```bash
kubectl logs busybox
```
