# CKAD

## Exam Tips

### Imperative Commands

#### Create a pod

```bash
Create a NGINX pod

kubectl run nginx --image=nginx
```

```bash
Generate a pod manifest

kubectl run nginx --image=nginx --dry-run=client -o yaml

```

#### Create a deployment

```bash
Create a deployment

kubectl create deployment nginx --image=nginx
```

```bash
Generate a deployment manifest

kubectl create deployment nginx --image=nginx --dry-run=client -o yaml
```

```bash
Generate a deployment manifest with 4 replicas

kubectl create deployment nginx --image=nginx --replicas=4 --dry-run=client -o yaml
```

```bash

Another way to do this is to save the YAML definition to a file and modify

kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml

```