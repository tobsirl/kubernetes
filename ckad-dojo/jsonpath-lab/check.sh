#!/usr/bin/env bash
# Usage:
#   ./check.sh N            show the expected output for challenge N
#   ./check.sh N --answer   reveal the command for challenge N
#   ./check.sh all          show every expected output
NS="-n jsonpath-lab"
declare -A A
A[1]="kubectl get po $NS -o jsonpath='{.items[0].metadata.name}'"
A[2]="kubectl get po $NS -o jsonpath='{.items[*].metadata.name}'"
A[3]="kubectl get deploy web $NS -o jsonpath='{.spec.template.spec.containers[0].image}'"
A[4]="kubectl get deploy web $NS -o jsonpath='{.spec.template.spec.containers[*].name}'"
A[5]="kubectl get deploy api $NS -o jsonpath='{.spec.replicas}'"
A[6]="kubectl get po $NS -o jsonpath='{range .items[*]}{.metadata.name}{\"\\n\"}{end}'"
A[7]="kubectl get po $NS -o jsonpath='{range .items[*]}{.metadata.name}{\"\\t\"}{.spec.nodeName}{\"\\n\"}{end}'"
A[8]="kubectl get po db $NS -o jsonpath='{.status.podIP}'"
A[9]="kubectl get deploy web $NS -o jsonpath='{.metadata.labels.tier}'"
A[10]="kubectl get deploy web $NS -o jsonpath='{.metadata.labels.app\\.kubernetes\\.io/name}'"
A[11]="kubectl get deploy web $NS -o jsonpath='{.spec.template.spec.containers[?(@.name==\"sidecar\")].image}'"
A[12]="kubectl get po $NS -l app=web -o jsonpath='{.items[*].metadata.name}'"
A[13]="kubectl get cm app-config $NS -o jsonpath='{.data.LOG_LEVEL}'"
A[14]="kubectl get cm app-config $NS -o jsonpath='{.data.app\\.properties}'"
A[15]="kubectl get secret db-creds $NS -o jsonpath='{.data.password}' | base64 -d"
A[16]="kubectl get svc web-svc $NS -o jsonpath='{.spec.ports[0].port} {.spec.ports[0].targetPort}'"
A[17]="kubectl get svc api-svc $NS -o jsonpath='{.spec.ports[0].nodePort}'"
A[18]="kubectl get deploy web $NS -o jsonpath='{.spec.template.spec.containers[?(@.name==\"web\")].resources.limits.memory}'"
A[19]="kubectl get po db $NS -o jsonpath='{.spec.securityContext.runAsUser}'"
A[20]="kubectl get deploy web $NS -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name==\"MODE\")].value}'"
A[21]="kubectl get po $NS -o jsonpath='{range .items[*]}{.metadata.name}{\" \"}{.status.phase}{\"\\n\"}{end}'"
A[22]="kubectl get deploy $NS -o jsonpath='{range .items[*]}{.metadata.name}{\"=\"}{.spec.replicas}{\"\\n\"}{end}'"
A[23]="kubectl get po $NS -o jsonpath='{.items[*].spec.containers[*].image}'"
A[24]="kubectl get po $NS -o jsonpath='{range .items[*]}{.metadata.name}{\": \"}{.spec.containers[*].name}{\"\\n\"}{end}'"
A[25]="kubectl get po db $NS -o jsonpath='{.spec.volumes[?(@.configMap)].configMap.name}'"
A[26]="kubectl get po $NS -o jsonpath='{range .items[*]}{.metadata.name}{\" \"}{.status.containerStatuses[*].restartCount}{\"\\n\"}{end}'"
A[27]="kubectl get po $NS -l tier=backend -o jsonpath='{.items[*].status.podIP}'"
A[28]="kubectl get po $NS --sort-by=.metadata.name -o custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[0].image"

show() {
  echo "── Challenge $1 ──"
  if [ "$2" = "--answer" ]; then echo "${A[$1]}"; echo; fi
  eval "${A[$1]}"; echo
}
if [ "$1" = "all" ]; then for i in $(seq 1 28); do show "$i"; done
elif [ -n "${A[$1]}" ]; then show "$1" "$2"
else echo "Usage: ./check.sh N [--answer] | all   (N = 1-28)"; fi
