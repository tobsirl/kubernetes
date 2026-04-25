## Notes

---

### 📝 Kubernetes Deployment Error – `containers` must be a list (4-dojo-kappa Q1)

**Error:**

```
cannot unmarshal object into Go struct field PodSpec.spec.template.spec.containers of type []v1.Container
```

**Cause:**

- The `containers` field was defined as an **object** instead of a **list (array)**.
- Kubernetes expects `containers` to be of type `[]v1.Container` (a list), even if there is only one container.

**Incorrect:**

```yaml
containers:
  name: api
  image: nginx
```

**Correct:**

```yaml
containers:
  - name: api
    image: nginx
```

**Key takeaway:**

- Always use `-` under `containers:` to define each container.
- Many Kubernetes fields (like `containers`, `ports`, `env`) expect lists.

**Tip:**

- If you see `cannot unmarshal object into Go struct field ... of type []...`, it usually means:
  → You forgot a `-` (list item)

---

### 📝 Kubernetes Security Context Error – Wrong Placement in Deployment (4-dojo-kappa Q11)

**Error / Issue:**

- Security context was added at the **wrong level** in the Deployment manifest.
- Placing `securityContext` under the top-level `spec:` (Deployment spec) does **not apply it to Pods or containers**.

---

### **Cause:**

- In a Deployment, there are multiple `spec` levels:
  - `Deployment.spec` → controls the Deployment itself
  - `Deployment.spec.template.spec` → defines the **Pod spec**

- Security settings must be applied at the **Pod level or container level inside the Pod template**, not at the Deployment level.

---

### **Incorrect (common mistake):**

```yaml
spec:
  securityContext:
    runAsUser: 1000 # ❌ Wrong level (Deployment spec)
```

---

### **Correct:**

```yaml
spec:
  template:
    spec:
      securityContext:
        runAsUser: 1000 # ✅ Pod-level security context
      containers:
        - name: app
          securityContext:
            capabilities:
              add:
                - NET_ADMIN # ✅ Container-level security context
```

---

### **Key Takeaways:**

- **Pod-level security context** goes under:

  ```
  spec.template.spec.securityContext
  ```

- **Container-level security context** goes under:

  ```
  spec.template.spec.containers[].securityContext
  ```

- Deployment structure matters — always follow:

  ```
  Deployment → template → spec → containers
  ```

---

### **Tip:**

- If your configuration is **not taking effect**, check:
  → Are you editing the **Pod template (`spec.template.spec`)**?

- Rule of thumb:
  - If it's about **how the Pod runs** → Pod `securityContext`
  - If it's about **specific container permissions** → Container `securityContext`

---

### **Verification Commands:**

```bash
kubectl rollout status deploy secure-app -n cascade
kubectl get pod -n cascade -l app=secure-app -o yaml | grep -A 10 securityContext
```

---

### **Exam Insight:**

- Kubernetes exams often test **YAML structure awareness**, not just concepts.
- Misplacing fields (like `securityContext`) is a **very common failure point**, similar to forgetting `-` in lists.

### 📝 Kubernetes `kubectl expose` – Creating Services Quickly

**Purpose:**

- `kubectl expose` is used to **create a Service from an existing resource** (usually a Deployment or Pod).
- It’s a fast alternative to writing YAML.

---

### ✅ **Basic Usage**

```bash
kubectl expose <resource-type> <resource-name> [flags]
```

---

### 🔧 **Common Example (Create a NodePort Service)**

```bash
kubectl expose deployment api-server \
  --name=api-nodeport \
  --type=NodePort \
  --port=80 \
  --target-port=9090
```

---

### 🧠 **What happens under the hood**

- Kubernetes:
  - Reads the **labels from the Deployment selector**
  - Automatically sets the Service **selector**
  - Creates a Service that routes traffic to matching Pods

---

### 📌 **Key Flags**

| Flag            | Meaning                                     |
| --------------- | ------------------------------------------- |
| `--name`        | Name of the Service                         |
| `--type`        | ClusterIP (default), NodePort, LoadBalancer |
| `--port`        | Service port                                |
| `--target-port` | Container port                              |
| `--protocol`    | TCP/UDP (default TCP)                       |

---

### ⚠️ **Common Mistakes**

#### ❌ Exposing a Service that doesn’t exist

```bash
kubectl expose service api-nodeport ...
```

→ Fails with:

```
Error: services "api-nodeport" not found
```

✔ Because `expose service` expects an **existing Service**

---

#### ❌ Misusing `-l` (selector flag)

```bash
-l app=api
```

- Often **unnecessary**
- When exposing a Deployment:
  → selector is **automatically inherited**

---

### ✅ **Best Practice**

- Use `expose deployment` to **create Services**
- Avoid manually setting selectors unless needed
- Use YAML only when:
  - You need precise control
  - You want to version configs

---

### 🔍 **Verify Service**

```bash
kubectl get svc
kubectl describe svc <name>
```

Check:

- `Selector` ✅ (must match Pods)
- `Port` / `TargetPort` ✅
- `NodePort` (if applicable) ✅

---

### 🧩 **Expose vs Create Service**

| Task                           | Command                          |
| ------------------------------ | -------------------------------- |
| Quick Service from Deployment  | `kubectl expose deployment`      |
| Full control / explicit config | `kubectl create service` or YAML |

---

### 💡 **Tip (Exam Gold 🧠)**

If the task says:

> “Create a Service for an existing Deployment”

👉 Use:

```bash
kubectl expose deployment ...
```

---

### 🔑 **Key Takeaway**

- `kubectl expose` = **fastest way to create a Service from existing resources**
- It **auto-handles selectors**, reducing errors
- Most useful for **exam scenarios and quick setups**
