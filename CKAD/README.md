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