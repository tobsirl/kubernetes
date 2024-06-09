# Kubernetes

## Imperative

### Service Object

### Commands

`kubectl create deployment first-app --image=tobsirl/kub-first-app` - Create a deployment

`kubectl get deployments` - List all deployments

`kubectl expose deployments` - Expose a deployment, service, or pod to the internet

`kubectl expose --type`

| Type         | Description                                                            |
| ------------ | ---------------------------------------------------------------------- |
| ClusterIP    | Exposes the service on a cluster-internal IP.                          |
| NodePort     | Exposes the service on each Node’s IP at a static port (the NodePort). |
| LoadBalancer | Exposes the service externally using a cloud provider’s load balancer. |

`kubectl get services` - List all services

`kubectl scale deployments/first-app --replicas=3` - Scale the deployment

## Declarative

Using Kubernetes in a declarative way means that you describe the desired state in a YAML file and then apply it to the cluster. Kubernetes will then make the necessary changes to the cluster to make the current state match the desired state.

Example: `kubectl apply -f first-app.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: first-app
spec:
    replicas: 3
    selector:
        matchLabels:
        app: first-app
    template:
        metadata:
        labels:
            app: first-app
        spec:
        containers:
            - name: first-app
            image: tobsirl/kub-first-app
            ports:
                - containerPort: 8080
```

### Oh My Zsh - kubectl plugin

[Kubectl plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl)https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl

### Commands

# Minikube

`minikube service first-app` - Open the service in the browser

### Commands

`minikube start` - Start minikube

`minikube status` - Get the status of minikube

`minikube stop` - Stop minikube

`minikube services list` - List all services

`minikube dashboard` - Open the dashboard in the browser

`minikube delete` - Delete minikube

# Kustomize

## What is Kustomize?

Kustomize is a tool that lets you create an entire Kubernetes application out of individual pieces of YAML. It lets you customize each piece of YAML with different values for different environments, and then combine them all together into a single YAML file.

Kustomize is built into kubectl, so you can use it without installing anything extra.
