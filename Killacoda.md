# CKAD Practice with Killercoda

[Killercoda](https://killercoda.com/) provides free browser-based Kubernetes environments — perfect for CKAD exam prep without needing a local cluster.

## Resources

| Resource                         | Link                                                   |
| -------------------------------- | ------------------------------------------------------ |
| Killercoda Platform              | https://killercoda.com/                                |
| Pre-exam Notes (lab questions)   | https://github.com/vloidcloudtech/Pre-exam-Notes       |
| CKAD Practice Questions (source) | https://github.com/aravind4799/CKAD-Practice-Questions |

## How to Practice

1. Open a Killercoda Kubernetes playground
2. Clone the pre-exam notes repo:

   ```bash
   git clone https://github.com/vloidcloudtech/Pre-exam-Notes.git
   ```

3. Navigate to the CKAD labs directory:

   ```bash
   cd Pre-exam-Notes/K8s/CKAD/ckad-labs
   ```

4. Pick a question (e.g. Q01) and review it:

   ```bash
   cd Q01
   cat QUESTION.md
   ```

5. Run the setup script to configure the environment for that question:

   ```bash
   bash setup.sh
   ```

6. Attempt the question, then move on to the next one (`cd ../Q02`, etc.)

## Tips

- Each `Q##` folder contains a `QUESTION.md` with the problem and a `setup.sh` to prepare the cluster
- Try solving each question under time pressure to simulate exam conditions
- Use `kubectl explain <resource>` and the [Kubernetes docs](https://kubernetes.io/docs/) — both are allowed during the real exam
