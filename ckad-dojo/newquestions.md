## Question 1 | kubectl explain

### Solution

```bash
# Navigate the API documentation
kubectl explain pod.spec.containers.resources

# Save to file
kubectl explain pod.spec.containers.resources --recursive > ./exam/course/1/pod-spec-fields.txt
```

### Explanation: kubectl explain provides built-in documentation for Kubernetes API resources. Use dot notation to navigate nested fields. The --recursive flag shows all sub-fields.
