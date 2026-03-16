# Questions Exam 1

## Question 1 | API Resources

### Solution:

```
# List all API resources and save to file

kubectl api-resources > ./exam/course/1/api-resources
```

### Explanation: The kubectl api-resources command lists all available API resources in the cluster, including their shortnames, API group, and whether they are namespaced. This is useful for discovering what resources are available.
