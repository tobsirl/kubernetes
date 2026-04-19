## Notes

---

### 📝 Kubernetes Deployment Error – `containers` must be a list

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

#### Issue:

- 4-dojo-kappa Q1
