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

# Minikube

`minikube service first-app` - Open the service in the browser

### Commands

`minikube start` - Start minikube
