# jsonpath lab (28 challenges)

## Setup
    kubectl apply -f lab.yaml
    kubectl get all -n jsonpath-lab     # wait until pods are Running

Every challenge uses `-n jsonpath-lab`. Write the command yourself first, then check:

    ./check.sh 7            # expected output only
    ./check.sh 7 --answer   # reveal the command too

Clean up afterwards: `kubectl delete ns jsonpath-lab`

Tips before you start:
- Explore the structure first: `k get po db -n jsonpath-lab -o yaml` (or `-o json | less`).
- `get <type>` without a name returns a List, so paths start with `.items[...]`.
  `get <type> <name>` returns one object, so paths start at `.metadata`, `.spec`...
- Wrap jsonpath in single quotes, and use double quotes inside it.

## Level 1: single values
1. Name of the first pod in the namespace.
2. Names of all pods, on one line.
3. Image of the first container in Deployment `web`.
4. Names of all containers in Deployment `web`.
5. Replica count of Deployment `api`.

## Level 2: one per line and multiple fields
6. All pod names, one per line (`range` / `end`).
7. Each pod's name and the node it runs on, tab-separated, one pod per line.
8. IP address of pod `db`.

## Level 3: labels, dots in keys, filters
9. Value of the `tier` label on Deployment `web`.
10. Value of the `app.kubernetes.io/name` label on Deployment `web` (the key has dots).
11. Image of the container named `sidecar` in Deployment `web`, using a filter (not an index).
12. Names of the pods with label `app=web` (combine `-l` with jsonpath).

## Level 4: config and services
13. Value of `LOG_LEVEL` in ConfigMap `app-config`.
14. Contents of the `app.properties` key in ConfigMap `app-config`.
15. Decoded password from Secret `db-creds`.
16. Port and targetPort of Service `web-svc`, separated by a space.
17. The nodePort of Service `api-svc`.

## Level 5: nested filters, exam-style checks
18. Memory limit of the `web` container in Deployment `web`, using a filter.
19. `runAsUser` from pod `db`'s pod-level securityContext.
20. Value of the `MODE` env var in Deployment `web`'s first container.
21. Each pod's name and phase, one per line.
22. Every Deployment as `name=replicas`, one per line.

## Level 6: harder
23. Every container image used by every pod, on one line.
24. Each pod's name followed by its container names, e.g. `db: db`.
25. Name of the ConfigMap that pod `db` mounts as a volume (filter on volumes that have a `configMap` field).
26. Each pod's name and the restart counts of its containers.
27. IPs of the pods with label `tier=backend`.
28. Bonus (not jsonpath): a table of pod NAME and IMAGE, sorted by name, using `custom-columns` and `--sort-by`.

## Stretch
Redo 7, 21 and 22 against your dojo namespaces, and write each one from memory in under 30 seconds.
That speed is what you need on exam day for verifying your own work.
