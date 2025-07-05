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
