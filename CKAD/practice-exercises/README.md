# CKAD Exericises

## Create a namespace called 'mynamespace' and a pod with image nginx called nginx on this namespace

```bash
kubectl create namespace mynamespace
kubectl run nginx --image=nginx --restart=Never -n mynamespace
```

## Create a pod that was just described using YAML

```bash
kubectl run nginx --image=nginx --restart=Never --dry-run=client -n mynamespace -o yaml > pod.yaml

cat pod.yaml

kubectl apply -f pod.yaml -n mynamespace
```

## Create a busybox pod (using kubectl command) that runs the command "env". Run it and see the output

```bash
kubectl run busybox --image=busybox --restart=Never --command -it --rm -- env

kubectl run busybox --image=busybox --command --restart=Never -- env

kubectl logs busybox
```

## Get the YAML for a new namespace called 'myns' without creating it

```bash
kubectl create namespace myns --dry-run=client -o yaml
```

## Create a busybox pod (using YAML) that runs the command "env". Run it and see the output

```bash
kubectl run busybox --image=busybox --restart=Never --command --dry-run=client -- env -o yaml > envpod.yaml
cat envpod.yaml
kubectl apply -f envpod.yaml
kubectl logs busybox
```

## Get the YAML for a new ResourceQuota called 'myrq' with hard limits of 1 CPU, 1G memory and 2 pods without creating it

```bash
kubectl create resourcequota myrq --hard=cpu=1,memory=1Gi,pods=2 --dry-run=client -o yaml
```

## Get pods on all namespaces

```bash
kubectl get pods --all-namespaces
kubectl get pods -A
```

## Create a pod with image nginx called nginx and expose traffic on port 80

```bash
kubectl run nginx --image=nginx --restart=Never --port=80
```

## Change pod's image to nginx:1.7.1. Observe that the container will be restarted as soon as the image gets pulled

Note: The RESTARTS column should contain 0 initially (ideally - it could be any number)

```bash
# Note: The RESTARTS column should contain 0 initially (ideally - it could be any number)
kubectl set image pod/nginx nginx=nginx:1.7.1
kubectl get pods nginx
kubectl describe pod nginx # you will see an event "Container will be killed and re-created" in the events section
kubectl get pod nginx -w # Watch it
# Note: some time after changing the image, you should see that the value in the RESTARTS column has been increased by 1, because the container has been restarted, as stated in the events shown at the bottom of the kubectl describe pod command:

# Note: you can check pod's image by running:
kubectl get pod nginx -o jsonpath='{.spec.containers[].image}{"\n"}'
```

## Get nginx pod's ip created in previous step, use a temp busybox image to wget its '/'

```bash
kubectl get po -o wide # get the IP, will be something like '10.1.1.131'
# create a temp busybox pod
kubectl run busybox --image=busybox --rm -it --restart=Never -- wget -O- 10.1.1.131:80
```

## Get pod's YAML

```bash
kubectl get pod nginx -o yaml
```

## Get information about the pod, including details about potential issues (e.g. pod hasn't started)

```bash
kubectl describe pod nginx
```

## Get pod's logs

```bash
kubectl logs nginx
```

## If the pod crashed and restarted, get the logs of the previous instance

```bash
kubectl logs nginx -p
kubectl logs nginx --previous
```

## Execute a simple shell on the nginx pod

```bash
kubectl exec -it nginx -- /bin/sh
```

## Create a busybox pod that echoes 'hello world' and then exits

```bash
kubectl run busybox --image=busybox --restart=Never --command -- echo "hello world"
kubectl logs busybox
```

## Create a busybox pod that echoes 'hello world' and then exits, but have the pod deleted automatically when it's completed

```bash
kubectl run busybox --image=busybox --restart=Never --command -it --rm -- echo "hello world"
kubectl logs busybox
# Note: you will not be able to get the logs after the pod is deleted
# kubectl logs busybox # will not work, because the pod is deleted
```

## Create an nginx pod and set an env value as 'var1=val1'. Check the env value existence within the pod

```bash
kubectl run nginx --image=nginx --restart=Never --env="var1=val1"
kubectl exec -it nginx -- env   # This will show all environment variables, including 'var1=val1'
kubectl exec -it nginx -- sh -c 'echo $var1'
kubectl describe pod nginx | grep -i env
kubectl run nginx --restart=Never --image=nginx --env=var1=val1 -it --rm -- env
kubectl run nginx --image nginx --restart=Never --env=var1=val1 -it --rm -- sh -c 'echo $var1'
```

## If pod crashed and restarted, get logs about the previous instance

```bash
kubectl logs nginx -p
kubectl logs nginx --previous
```

## Create a Pod with two containers, both with image busybox and command "echo hello; sleep 3600". Connect to the second container and run 'ls'

```bash
kubectl run busybox --image=busybox --restart=Never -o yaml --dry-run=client -- /bin/sh -c 'echo hello;sleep 3600' > pod.yaml vi pod.yaml

Copy/paste the container related values, so your final YAML should contain the following two containers (make sure those containers have a different name):

---
containers:
  - args:
    - /bin/sh
    - -c
    - echo hello;sleep 3600
    image: busybox
    imagePullPolicy: IfNotPresent
    name: busybox
    resources: {}
  - args:
    - /bin/sh
    - -c
    - echo hello;sleep 3600
    image: busybox
    name: busybox2
---

kubectl create -f pod.yaml

# Connect to the busybox2 container within the pod
kubectl exec -it busybox -c busybox2 -- /bin/sh
ls
exit

# or you can do the above with just an one-liner
kubectl exec -it busybox -c busybox2 -- ls
# you can do some cleanup

```

## Get pod logs

```bash
kubectl logs busybox
```

## Create a pod with an nginx container exposed on port 80. Add a busybox init container which downloads a page using "wget -O /work-dir/index.html http://neverssl.com/online". Make a volume of type emptyDir and mount it in both containers. For the nginx container, mount it on "/usr/share/nginx/html" and for the initcontainer, mount it on "/work-dir". When done, get the IP of the created pod and create a busybox pod and run "wget -O- IP"

```bash
Easiest way to do it is create a pod with a single container and save its definition in a YAML file:

$> kubectl run box --image=nginx --restart=Never --port=80 --dry-run=client -o yaml > pod-init.yaml

Copy/paste the container related values, so your final YAML should contain the volume and the initContainer:

Volume:

---
containers:
- image: nginx
...
  volumeMounts:
  - name: vol
    mountPath: /usr/share/nginx/html
volumes:
- name: vol
  emptyDir: {}
---

initContainer:

---
...
initContainers:
- args:
  - /bin/sh
  - -c
  - "wget -O /work-dir/index.html http://neverssl.com/online"
  image: busybox
  name: box
  volumeMounts:
  - name: vol
    mountPath: /work-dir
---

In total you get:

---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: box
  name: box
spec:
  initContainers:
  - args:
    - /bin/sh
    - -c
    - "wget -O /work-dir/index.html http://neverssl.com/online"
    image: busybox
    name: box
    volumeMounts:
    - name: vol
      mountPath: /work-dir
  containers:
  - image: nginx
    name: nginx
    ports:
    - containerPort: 80
    volumeMounts:
    - name: vol
      mountPath: /usr/share/nginx/html
  volumes:
  - name: vol
    emptyDir: {}
---

# Apply pod
$> kubectl apply -f pod-init.yaml

# Get IP
$> kubectl get po -o wide

# Execute wget
$> kubectl run box-test --image=busybox --restart=Never -it --rm -- /bin/sh -c "wget -O- $(kubectl get pod box -o jsonpath='{.status.podIP}')"

# you can do some cleanup
$> kubectl delete po box
```

## Show all labels of the pods

```bash
kubectl get pods --show-labels
```

## Get the label 'app' for the pods (show a column with APP labels)

```bash
kubectl get pods -L app
```

## Get only the 'app=v2' pods

```bash
kubectl get pods -l app=v2
```

## Add a new label tier=web to all pods having 'app=v2' or 'app=v1' labels

```bash
kubectl label po -l "app in(v1,v2)" tier=web
```

## Add an annotation 'owner: marketing' to all pods having 'app=v2' label

```bash
kubectl annotate pod -l app=v2 owner=marketing
```

## Remove the 'app' label from the pods we created before

```bash
kubectl label pod nginx1 nginx2 nginx3 app-
kubectl label pod nginx{1..3} app-
kubectl label pod -l app app-
```

## Annotate pods nginx1, nginx2, nginx3 with "description='my description'" value

```bash
kubectl annotate pod nginx1 nginx2 nginx3 description='my description'
kubectl annotate pod nginx{1..3} description='my description'
```

## Check the annotations for pod nginx1

```bash
kubectl annotate pod nginx1 --list
kubectl describe pod nginx1 | grep -i annotation
kubectl get pod nginx1 -o jsonpath='{.metadata.annotations}{"\n"}'
```

## Remove the annotations for these three pods

```bash
kubectl annotate pod nginx1 nginx2 nginx3 description-
kubectl annotate pod nginx{1..3} description-
```

## Remove these pods to have a clean state in your cluster

```bash
kubectl delete pod nginx1 nginx2 nginx3
kubectl delete pod nginx{1..3}
```

## Taint a node with key tier and value frontend with effect NoShedule. Then, create a pod that tolerates this taint.

```bash
Taint a node:

kubectl taint node node1 tier=frontend:NoSchedule # key=value:Effect
kubectl describe node node1 # view the taints on a node

And to tolerate the taint:

---
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "tier"
    operator: "Equal"
    value: "frontend"
    effect: "NoSchedule"
---
```

## Create a pod that will be placed on node controlplane. Use nodeSelector and tolerations.

```bash
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  image:
    name: nginx
    image: nginx
  nodeSelector:
    kubernetes.io/hostname: controlplane
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
---

kubectl create -f pod.yaml
```

## Create a pod that will be deployed to a Node that has the label 'accelerator=nvidia-tesla-p100'

```bash
Add the label to a node:

kubectl label nodes <your-node-name> accelerator=nvidia-tesla-p100
kubectl get nodes --show-labels

We can use the 'nodeSelector' property on the Pod YAML:

---
apiVersion: v1
kind: Pod
metadata:
  name: cuda-test
spec:
  containers:
    - name: cuda-test
      image: "k8s.gcr.io/cuda-vector-add:v0.1"
  nodeSelector: # add this
    accelerator: nvidia-tesla-p100 # the selection label
---

You can easily find out where in the YAML it should be placed by:

kubectl explain po.spec

OR: Use node affinity (https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/#schedule-a-pod-using-required-node-affinity)

---
apiVersion: v1
kind: Pod
metadata:
  name: affinity-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: accelerator
            operator: In
            values:
            - nvidia-tesla-p100
  containers:
    ...
---
```

## Delete the deployment and the horizontal pod autoscaler you created

```bash
kubectl delete deployment nginx-deployment
kubectl delete hpa nginx-deployment
```

## Implement canary deployment by running two instances of nginx marked as version=v1 and version=v2 so that the load is balanced at 75%-25% ratio

```bash
Deploy 3 replicas of v1:

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-v1
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
      version: v1
  template:
    metadata:
      labels:
        app: my-app
        version: v1
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: workdir
          mountPath: /usr/share/nginx/html
      initContainers:
      - name: install
        image: busybox:1.28
        command:
        - /bin/sh
        - -c
        - "echo version-1 > /work-dir/index.html"
        volumeMounts:
        - name: workdir
          mountPath: "/work-dir"
      volumes:
      - name: workdir
        emptyDir: {}
---

Create the service:

---
apiVersion: v1
kind: Service
metadata:
  name: my-app-svc
  labels:
    app: my-app
spec:
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: 80
  selector:
    app: my-app
---

Test if the deployment was successful from within a Pod:
# run a wget to the Service my-app-svc
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox --command -- wget -qO- my-app-svc

version-1

Deploy 1 replica of v2:

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-v2
  labels:
    app: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
      version: v2
  template:
    metadata:
      labels:
        app: my-app
        version: v2
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: workdir
          mountPath: /usr/share/nginx/html
      initContainers:
      - name: install
        image: busybox:1.28
        command:
        - /bin/sh
        - -c
        - "echo version-2 > /work-dir/index.html"
        volumeMounts:
        - name: workdir
          mountPath: "/work-dir"
      volumes:
      - name: workdir
        emptyDir: {}
---

Observe that calling the ip exposed by the service the requests are load balanced across the two versions:

# run a busyBox pod that will make a wget call to the service my-app-svc and print out the version of the pod it reached.
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox -- /bin/sh -c 'while sleep 1; do wget -qO- my-app-svc; done'

version-1
version-1
version-1
version-2
version-2
version-1



If the v2 is stable, scale it up to 4 replicas and shoutdown the v1:

kubectl scale --replicas=4 deploy my-app-v2
kubectl delete deploy my-app-v1
while sleep 0.1; do curl $(kubectl get svc my-app-svc -o jsonpath="{.spec.clusterIP}"); done
version-2
version-2
version-2
version-2
version-2
version-2
```

## Create a deployment with image nginx:1.18.0, called nginx, having 2 replicas, defining port 80 as the port that this container exposes (don't create a service for this deployment)

```bash
kubectl create deployment nginx  --image=nginx:1.18.0  --dry-run=client -o yaml > deploy.yaml
vi deploy.yaml

# change the replicas field from 1 to 2
# add this section to the container spec and save the deploy.yaml file
# ports:
#   - containerPort: 80
kubectl apply -f deploy.yaml

or,
kubectl create deploy nginx --image=nginx:1.18.0 --replicas=2 --port=80
```

## View the YAML of this deployment

```bash
kubectl get deploy nginx -o yaml
```

## View the YAML of the replica set that was created by this deployment

```bash
kubectl describe deploy nginx # you'll see the name of the replica set on the Events section and in the 'NewReplicaSet' property

# OR you can find rs directly by:
kubectl get rs -l run=nginx # if you created deployment by 'run' command
kubectl get rs -l app=nginx # if you created deployment by 'create' command

# you could also just do kubectl get rs
kubectl get rs nginx-7bf7478b77 -o yaml
```

## Check how the deployment rollout is going

```bash
kubectl rollout status deploy/nginx
```

## Update the nginx image to nginx:1.19.8

```bash
kubectl set image deploy/nginx nginx=nginx:1.19.8

# alternatively...
kubectl edit deploy nginx # change the .spec.template.spec.containers[0].image

The syntax of the 'kubectl set image' command is kubectl set image (-f FILENAME | TYPE NAME) CONTAINER_NAME_1=CONTAINER_IMAGE_1 ... CONTAINER_NAME_N=CONTAINER_IMAGE_N [options]
```

## Check the rollout history and confirm that the replicas are OK

```bash
kubectl rollout history deploy/nginx
kubectl get deploy nginx
kubectl get rs # check that a new replica set was created
kubectl get pods -l app=nginx # check that the pods are running
```

## Undo the latest rollout and verify that new pods have the old image (nginx:1.18.0)

```bash
kubectl rollout undo deploy/nginx
# wait a bit
kubectl get po # select one 'Running' Pod
kubectl describe po nginx-5ff4457d65-nslcl | grep -i image # should be nginx:1.18.0
```

## Do an on purpose update of the deployment with a wrong image nginx:1.91

```bash
kubectl set image deploy/nginx nginx=nginx:1.91
```

## Verify that something's wrong with the rollout

```bash
kubectl rollout status deploy/nginx
kubectl get pod nginx
# check for 'ErrImagePull' or 'ImagePullBackOff' in the REASON column
```

## Return the deployment to the second revision (number 2) and verify the image is nginx:1.19.8

```bash
kubectl rollout undo deploy nginx --to-revision=2
kubectl describe deploy nginx | grep -i image
kubectl rollout status deploy nginx # Everything should be OK now
```

## Check the details of the fourth revision (number 4)

```bash
kubectl rollout history deploy nginx --revision=4 # You'll see the wrong image displayed here
```

## Scale the deployment to 5 replicas

```bash
kubectl scale deploy nginx --replicas=5
kubectl get pods
kubectl describe deploy nginx | grep -i replicas
```

## Autoscale the deployment, pods between 5 and 10, targetting CPU utilization at 80%

```bash
kubectl autoscale deploy nginx --min=5 --max=10 --cpu-percent=80
kubectl get hpa nginx # check the Horizontal Pod Autoscaler
```

## Pause the rollout of the deployment

```bash
kubectl rollout pause deploy nginx
```

## Update the image to nginx:1.19.9 and check that there's nothing going on, since we paused the rollout

```bash
kubectl set image deploy nginx nginx=nginx:1.19.9

# or
kubectl edit deploy nginx # change the .spec.template.spec.containers[0].image to nginx:1.19.9
# change the image to nginx:1.19.9
kubectl rollout history deploy nginx # no new revision is created
```

## Resume the rollout and check that the nginx:1.19.9 image has been applied

```bash
kubectl rollout resume deploy nginx
kubectl rollout status deploy nginx # should be OK
kubectl rollout history deploy nginx # should show a new revision with nginx:1.19.9
```

## Create a job named pi with image perl:5.34 that runs the command with arguments "perl -Mbignum=bpi -wle 'print bpi(2000)'"

```bash
kubectl create job pi --image=perl:5.34 -- perl -Mbignum=bpi -wle 'print bpi(2000)'
```

## After creating a job named pi with image perl:5.34 that runs the command with arguments "perl -Mbignum=bpi -wle 'print bpi(2000)'", wait till it's done, get the output

```bash
kubectl get jobs -w # wait till 'SUCCESSFUL' is 1 (will take some time, perl image might be big)
kubectl logs pi-**** # get the pi numbers
kubectl get po # get the pod name
kubectl delete job pi

OR

kubectl get jobs -w # wait till 'SUCCESSFUL' is 1 (will take some time, perl image might be big)
kubectl logs job/pi
kubectl delete job pi

OR

kubectl wait --for=condition=complete --timeout=300s job pi
kubectl logs job/pi
kubectl delete job pi
```

## Create a job with the image busybox that executes the command 'echo hello;sleep 30;echo world'

```bash
kubectl create job echo-job --image=busybox -- /bin/sh -c 'echo hello;sleep 30;echo world'
```

## Follow the logs for the pod (you'll wait for 30 seconds)

```bash
kubectl get pods # get the pod name
kubectl logs busybox-ptx58 -f # follow the logs
```

## See the status of the job, describe it and see the logs

```bash
kubectl get jobs # check the status of the job
kubectl describe jobs busybox # see the details of the job
kubectl logs job/busybox # get the logs of the job
```

## Delete the job

```bash
kubectl delete job busybox
```

## Create a job but ensure that it will be automatically terminated by kubernetes if it takes more than 30 seconds to execute

```bash
kubectl create job busybox --image=busybox --dry-run=client -o yaml -- /bin/sh -c 'while true; do echo hello; sleep 10;done' > job.yaml
vi job.yaml

Add job.spec.activeDeadlineSeconds=30:
---
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  labels:
    run: busybox
  name: busybox
spec:
  activeDeadlineSeconds: 30 # add this line
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: busybox
    spec:
      containers:
      - args:
        - /bin/sh
        - -c
        - while true; do echo hello; sleep 10;done
        image: busybox
        name: busybox
        resources: {}
      restartPolicy: OnFailure
status: {}
---
```

## Create a job but ensure that it will be automatically terminated by kubernetes if it takes more than 30 seconds to execute. Make it run 5 paraller times

```bash
vi job.yaml

# Add job.spec.parallelism=5:
---
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  labels:
    run: busybox
  name: busybox
spec:
parallelism: 5 # add this line
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: busybox
    spec:
      containers:
      - args:
        - /bin/sh
        - -c
        - echo hello;sleep 30;echo world
        image: busybox
        name: busybox
        resources: {}
      restartPolicy: OnFailure
status: {}
---

kubectl create -f job.yaml
kubectl get jobs

# -w will watch the job status
kubectl get jobs -w

# It will take some time for the parallel jobs to finish (>= 30 seconds):

kubectl delete job busybox
```

## Create a cron job with image busybox that runs on a schedule of "_/1 _ \* \* \*" and writes 'date; echo Hello from the Kubernetes cluster' to standard output

```bash
kubectl create cronjob my-cronjob --image=busybox --schedule="*/1 * * * *" -- /bin/sh -c 'date; echo Hello from the Kubernetes cluster
```

## See logs of a cron job and delete it

```bash
kubectl get pods # copy the container just created
kubectl logs <container> # you will see the date and message
kubectl delete cj busybox --force # cj stands for cronjob --force to delete it immediately
```

## Create the same cron job again, and watch the status. Once it ran, check which job ran by the created cron job. Check the log, and delete the cron job

```bash
kubectl get cj
kubectl get jobs --watch # you will see the job created by the cron job
kubectl get po --show-labels # observe that the pods have a label that mentions their 'parent' job
kubectl logs busybox-1529745840-m867r

# Bear in mind that Kubernetes will run a new job/pod for each new cron job
kubectl delete cj busybox
```

## Create a cron job with image busybox that runs every minute and writes 'date; echo Hello from the Kubernetes cluster' to standard output. The cron job should be terminated if it takes more than 17 seconds to start execution after its scheduled time (i.e. the job missed its scheduled time).

```bash
kubectl create cronjob time-limited-job --image=busybox --restart=Never --dry-run=client --schedule="* * * * *" -o yaml -- /bin/sh -c 'date; echo Hello from the Kubernetes cluster' > time-limited-job.yaml vi time-limited-job.yaml


Add cronjob.spec.startingDeadlineSeconds=17:

---
apiVersion: batch/v1
kind: CronJob
metadata:
  creationTimestamp: null
  name: time-limited-job
spec:
  startingDeadlineSeconds: 17 # add this line
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: time-limited-job
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
          - args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
            image: busybox
            name: time-limited-job
            resources: {}
          restartPolicy: Never
  schedule: '* * * * *'
status: {}
---
```

## Create a cron job with image busybox that runs every minute and writes 'date; echo Hello from the Kubernetes cluster' to standard output. The cron job should be terminated if it successfully starts but takes more than 12 seconds to complete execution.

```bash
kubectl create cronjob time-limited-job --image=busybox --restart=Never --dry-run=client --schedule="* * * * *" -o yaml -- /bin/sh -c 'date; echo Hello from the Kubernetes cluster' > time-limited-job.yaml vi time-limited-job.yaml


Add cronjob.spec.jobTemplate.spec.activeDeadlineSeconds=12:

---
apiVersion: batch/v1
kind: CronJob
metadata:
  creationTimestamp: null
  name: time-limited-job
spec:
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: time-limited-job
    spec:
      activeDeadlineSeconds: 12 # add this line
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
          - args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
            image: busybox
            name: time-limited-job
            resources: {}
          restartPolicy: Never
  schedule: '* * * * *'
status: {}
---
```

## Create a job from cronjob

```bash
kubectl create job --from=cronjob/sample-cron-job sample-job
```

## Create a configmap named config with values foo=lala,foo2=lolo

```bash
kubectl create configmap config --from-literal=foo=lala --from-literal=foo2=lolo
```

## Display values of a configmap

```bash
kubectl get configmap config -o yaml
kubectl describe configmap config
```

## Create and display a configmap from a file. Create the file with: echo -e "foo3=lili\nfoo4=lele" > config.txt

```bash
kubectl create cm configmap2 --from-file=config.txt
kubectl get cm configmap2 -o yaml
```

## Create and display a configmap from a .env file. Create the file with the command: echo -e "var1=val1\n# this is a comment\n\nvar2=val2\n#anothercomment" > config.env

```bash
kubectl create cm configmap3 --from-env-file=config.env
kubectl get cm configmap3 -o yaml
```

## Create and display a configmap from a file, giving the key 'special'. Create the file with: echo -e "var3=val3\nvar4=val4" > config4.txt

```bash
kubectl create cm configmap4 --from-file=special=config4.txt
kubectl describe cm configmap4
kubectl get cm configmap4 -o yaml
```

## Create a configMap called 'options' with the value var5=val5. Create a new nginx pod that loads the value from variable 'var5' in an env variable called 'option'

```bash
kubectl create cm options --from-literal=var5=val5
kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    env:
    - name: option # name of the env variable
      valueFrom:
        configMapKeyRef:
          name: options # name of config map
          key: var5 # name of the entity in config map
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl exec -it nginx -- env | grep option # will show 'option=val5'
```

## Create a configMap 'anotherone' with values 'var6=val6', 'var7=val7'. Load this configMap as env variables into a new nginx pod

```bash
kubectl create configmap anotherone --from-literal=var6=val6 --from-literal=var7=val7
kubectl run --restart=Never nginx --image=nginx -o yaml --dry-run=client > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    envFrom: # different than previous one, that was 'env'
    - configMapRef: # different from the previous one, was 'configMapKeyRef'
        name: anotherone # the name of the config map
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl exec -it nginx -- env
```

## Create a configMap 'cmvolume' with values 'var8=val8', 'var9=val9'. Load this as a volume inside an nginx pod on path '/etc/lala'. Create the pod and 'ls' into the '/etc/lala' directory.

```bash
kubectl create configmap cmvolume --from-literal=var8=val8 --from-literal=var9=val9
kubectl run nginx --image=nginx --restart=Never -o yaml --dry-run=client > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  volumes: # add a volumes list
  - name: myvolume # just a name, you'll reference this in the pods
    configMap:
      name: cmvolume # name of your configmap
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    volumeMounts: # your volume mounts are listed here
    - name: myvolume # the name that you specified in pod.spec.volumes.name
      mountPath: /etc/lala # the path inside your container
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl exec -it nginx -- /bin/sh
cd /etc/lala
ls # will show var8 var9
cat var8 # will show val8
```

## Create the YAML for an nginx pod that runs with the user ID 101. No need to create the pod

```bash
kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  securityContext: # insert this line
    runAsUser: 101 # UID for the user
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---
```

## Create the YAML for an nginx pod that has the capabilities "NET_ADMIN", "SYS_TIME" added to its single container

```bash
kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    securityContext: # insert this line
      capabilities: # and this
        add: ["NET_ADMIN", "SYS_TIME"] # this as well
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---
```

## Create an nginx pod with requests cpu=100m,memory=256Mi and limits cpu=200m,memory=512Mi

```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"
        cpu: "200m"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
```

## Create a namespace with limit range

```bash
kubectl create ns one
vi 1.yaml:

---
apiVersion: v1
kind: LimitRange
metadata:
  name: ns-memory-limit
  namespace: one
spec:
  limits:
  - max: # max and min define the limit range
      memory: "500Mi"
    min:
      memory: "100Mi"
    type: Container
---

kubectl apply -f 1.yaml
```

## Describe the namespace limitrange

```bash
kubectl describe limitrange ns-memory-limit -n onekubectl describe limitrange -n one
```

## Create a pod with resources requests memory = half of max memory constraint in namespace

```bash
vi 2.yaml:

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
  namespace: one
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        memory: "250Mi"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

kubectl apply -f 2.yaml
```

## Create ResourceQuota in namespace one with hard requests cpu=1, memory=1Gi and hard limits cpu=2, memory=2Gi.

```bash
Create the namespace:

kubectl create ns one

Create the ResourceQuota:

vi rq-one.yaml

---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: my-rq
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
---

kubectl apply -f rq-one.yaml
```

## Attempt to create a pod with resource requests cpu=2, memory=3Gi and limits cpu=3, memory=4Gi in namespace one

```bash
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
  namespace: one
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        memory: "3Gi"
        cpu: "2"
      limits:
        memory: "4Gi"
        cpu: "3"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

kubectl create -f pod.yaml

Expected error message:

```

Error from server (Forbidden): error when creating "pod.yaml": pods "nginx" is forbidden: exceeded quota: my-rq, requested: limits.cpu=3,limits.memory=4Gi,requests.cpu=2,requests.memory=3Gi, used: limits.cpu=0,limits.memory=0,requests.cpu=0,requests.memory=0, limited: limits.cpu=2,limits.memory=2Gi,requests.cpu=1,requests.memory=1Gi

```

```

## Create a pod with resource requests cpu=0.5, memory=1Gi and limits cpu=1, memory=2Gi in namespace one

```bash
vi pod2.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
  namespace: one
spec:
  containers:
  - image: nginx
    name: nginx
    resources:
      requests:
        memory: "1Gi"
        cpu: "0.5"
      limits:
        memory: "2Gi"
        cpu: "1"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

kubectl create -f pod2.yaml

Show the ResourceQuota usage in namespace one:

kubectl get resourcequota -n one


NAME    AGE   REQUEST                                          LIMIT
my-rq   10m   requests.cpu: 500m/1, requests.memory: 3Mi/1Gi   limits.cpu: 1/2, limits.memory: 4Mi/2Gi
```

## Create a secret called mysecret with the values password=mypass

```bash
kubectl create secret generic mysecret --from-literal=password=mypass
```

## Create a secret called mysecret2 that gets key/value from a file. Create a file called username with the value admin: echo -n admin > username

```bash
kubectl create secret generic mysecret2 --from-file=username
```

## Get the value of mysecret2

```bash
kubectl get secret mysecret2 -o yaml
echo -n YWRtaW4= | base64 -d # on MAC it is -D, which decodes the value and shows 'admin'

Alternative using --jsonpath:
kubectl get secret mysecret2 -o jsonpath='{.data.username}' | base64 -d # on MAC it is -D

Alternative using --template:
kubectl get secret mysecret2 --template '{{.data.username}}' | base64 -d # on MAC it is -D

Alternative using jq:
kubectl get secret mysecret2 -o json | jq -r .data.username | base64 -d # on MAC it is -D
```

## Create an nginx pod that mounts the secret mysecret2 in a volume on path /etc/foo

```bash
kubectl run nginx --image=nginx --restart=Never -o yaml --dry-run=client > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  volumes: # specify the volumes
  - name: foo # this name will be used for reference inside the container
    secret: # we want a secret
      secretName: mysecret2 # name of the secret - this must already exist on pod creation
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    volumeMounts: # our volume mounts
    - name: foo # name on pod.spec.volumes
      mountPath: /etc/foo #our mount path
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl exec -it nginx -- /bin/bash
ls /etc/foo  # shows username
cat /etc/foo/username # shows admin
```

## Delete the pod you just created and mount the variable 'username' from secret mysecret2 onto a new nginx pod in env variable called 'USERNAME'

```bash
kubectl delete po nginx
kubectl run nginx --image=nginx --restart=Never -o yaml --dry-run=client > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    env: # our env variables
    - name: USERNAME # asked name
      valueFrom:
        secretKeyRef: # secret reference
          name: mysecret2 # our secret's name
          key: username # the key of the data in the secret
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl exec -it nginx -- env | grep USERNAME | cut -d '=' -f 2 # will show 'admin'
```

## See all the service accounts of the cluster in all namespaces

```bash
kubectl get sa --all-namespaces
kubectl get sa -A
```

## Create a new serviceaccount called 'myuser'

```bash
kubectl create sa myuser

Alternatively:
# let's get a template easily
kubectl get sa default -o yaml > sa.yaml
vim sa.yaml

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myuser
---

kubectl create -f sa.yaml
```

## Create an nginx pod that uses 'myuser' as a service account

```bash
kubectl run nginx --image=nginx --restart=Never -o yaml --dry-run=client > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  serviceAccountName: myuser # we use pod.spec.serviceAccountName
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

or:

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  serviceAccount: myuser # we use pod.spec.serviceAccount
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl describe pod nginx # will see that a new secret called myuser-token-***** has been mounted
```

## Generate an API token for the service account 'myuser'

```bash
kubectl create token myuser
```

## Create an nginx pod with a liveness probe that just runs the command 'ls'. Save its YAML in pod.yaml. Run it, check its probe status, delete it.

```bash
kubectl run nginx --image=nginx --restart=Never --dry-run=client -o yaml > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    livenessProbe: # our probe
      exec: # add this line
        command: # command definition
        - ls # ls command
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl describe pod nginx | grep -i liveness # run this to see that liveness probe works
kubectl delete -f pod.yaml
```

## Modify the pod.yaml file so that liveness probe starts kicking in after 5 seconds whereas the interval between probes would be 5 seconds. Run it, check the probe, delete it.

```bash
kubectl explain pod.spec.containers.livenessProbe # get the exact names

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    livenessProbe:
      initialDelaySeconds: 5 # add this line
      periodSeconds: 5 # add this line as well
      exec:
        command:
        - ls
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl describe po nginx | grep -i liveness
kubectl delete -f pod.yaml
```

## Create an nginx pod (that includes port 80) with an HTTP readinessProbe on path '/' on port 80. Again, run it, check the readinessProbe, delete it.

```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml --restart=Never --port=80 > pod.yaml
vi pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    resources: {}
    ports:
      - containerPort: 80 # Note: Readiness probes runs on the container during its whole lifecycle. Since nginx exposes 80, containerPort: 80 is not required for readiness to work.
    readinessProbe: # declare the readiness probe
      httpGet: # add this line
        path: / #
        port: 80 #
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
---

kubectl create -f pod.yaml
kubectl describe pod nginx | grep -i readiness # to see the pod readiness details
kubectl delete -f pod.yaml
```
