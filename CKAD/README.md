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

#### Create a service

```bash

Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379

kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

```

### Formatting Output with kubectl

The default output format is `human-readable` format. You can change the output format using the `-o` flag.

Here are some of the formats you can use:
1. `-o json` Output a JSON formatted API object.
1. `-o name` Print only the resource name and nothing else.
1. `-o wide` Output in the plain-text format with any additional information.
1. `-o yaml` Output a YAML formatted API object.