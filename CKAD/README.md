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

Examples:

- Output with JSON format

```bash
master $ kubectl create namespace test-123 --dry-run -o json
{
    "kind": "Namespace",
    "apiVersion": "v1",
    "metadata": {
        "name": "test-123",
        "creationTimestamp": null
    },
    "spec": {},
    "status": {}
}
master $
```

- Output with YAML format

```bash
master $ kubectl create namespace test-123 --dry-run -o yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: test-123
spec: {}
status: {}

```

- Output with wide format

```bash
master $ kubectl get pods -o wide
NAME      READY   STATUS    RESTARTS   AGE     IP          NODE     NOMINATED NODE   READINESS GATES
busybox   1/1     Running   0          3m39s   10.36.0.2   node01          <​none​>         <​none​>  
ningx     1/1     Running   0          7m32s   10.44.0.1   node03          <​none​>         <​none​> 
redis     1/1     Running   0          3m59s   10.36.0.1   node01          <​none​>         <​none​> 
master $
```

### Editing Resources

1. Run the command `kubectl edit <resource> <resource-name>`. This will open the resource in a text editor. When you try to save the file, it will be rejected if the resource is immutable.
2. A copy of the resource is saved in a temporary file. You can edit this file and save it with a different name. Then you can apply the changes using the `kubectl apply -f <filename>` command.
3. Delete the existing resource and create a new resource with the changes.

```bash
kubectl delete pod <pod-name>
```

4. You can extract the resource definition to a file and then apply the changes.

```bash
kubectl get pod <pod-name> -o yaml > pod-definition.yaml
```
