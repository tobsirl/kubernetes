# CKAD

## Exam Tips

### Imperative Commands

Create a pod

```bash
kubectl run nginx --image=nginx
```
Generate a pod manifest

```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml
```