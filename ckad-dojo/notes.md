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
