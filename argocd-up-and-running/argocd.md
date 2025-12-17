# Argo CD on kind with NGINX Ingress — Quickstart

These notes summarize and streamline the steps from kind-cluster.txt to stand up Argo CD on a local kind cluster fronted by ingress-nginx.

## Prerequisites

- kind, kubectl, helm, curl, jq installed
- Linux host (commands assume running from this repo folder)

## 1) Create kind cluster with Ingress ports

Create a cluster with host port mappings for 80/443 and a node label `ingress-ready=true`:

```bash
cat <<EOF2 | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF2
```

## 2) Install ingress-nginx

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  -f values-ingress-nginx.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

## 3) Install Argo CD (via Helm) with Ingress

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade -i argo-cd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f values-argocd-ingress.yaml
```

If you use a host like `argocd.upandrunning.local` in your ingress values, map it to localhost:

```bash
echo "127.0.0.1 argocd.upandrunning.local" | sudo tee -a /etc/hosts
```

## 4) Obtain an Argo CD API session (optional)

Use the Argo CD API to create a session token (replace placeholders):

```bash
curl -H "Content-Type: application/json" \
  -XPOST -k https://argocd.upandrunning.local/api/v1/session \
  -d '{"username":"<USERNAME>","password":"<TOKEN>"}' | jq -r
```

Tip: If you need the initial admin password, you can retrieve it from the secret created by the chart (namespace `argocd`).

## 5) Deploy sample Quarkus app (optional)

The example below installs a Quarkus Helm chart into the `demo` namespace. Ensure the `redhat-helm-charts/quarkus` chart is resolvable (add its Helm repo as needed) or adjust to your preferred sample app.

```bash
helm install quarkus-app --namespace demo --create-namespace --version 0.0.3 \
  --set build.enabled=false \
  --set deploy.route.enabled=false \
  --set image.name=quay.io/ablock/gitops-helm-quarkus \
  redhat-helm-charts/quarkus
```

## 6) Verify

```bash
kubectl get pods -n ingress-nginx
kubectl get pods -n argocd
kubectl get ingress -A
```

## Cleanup

```bash
kind delete cluster
```
