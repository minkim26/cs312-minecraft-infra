# CS312 Minecraft Infrastructure

A Minecraft Java server (1.21.4) built up over a CS312 systems administration course, from a single Docker container on EC2 to a monitored Kubernetes deployment. The whole stack is defined as code: Terraform provisions the cloud resources, Ansible configures the host, GitHub Actions builds the image, and Kubernetes runs it.

## Stack

| Layer | Tool |
|-------|------|
| Cloud | AWS EC2, ECR |
| Provisioning | Terraform |
| Configuration | Ansible |
| Container image | Docker (`itzg/minecraft-server`), built by GitHub Actions |
| Orchestration | k3s (single-node Kubernetes) |
| Observability | kube-prometheus-stack (Prometheus, Grafana, Alertmanager), `mc-monitor` sidecar |

## Stages

Each stage lives in its own folder and builds on the previous one.

| Stage | Folder | What it does |
|-------|--------|--------------|
| Ops 1: Manual server | none | Hand-built Paper server on EC2 with systemd. Documented in the runbook only; no code in this repo |
| Ops 2: Containerized server | [`ops2/`](ops2/) | Custom [`Dockerfile`](ops2/Dockerfile) (based on `itzg/minecraft-server`) published to ECR; world data on a volume, backups to S3 |
| Ops 3: Infrastructure automation | [`ops3/`](ops3/) | [`terraform/`](ops3/terraform/): EC2 instance and security group. [`ansible/`](ops3/ansible/): installs Docker and the AWS CLI, pulls the pinned image from ECR, optional S3 world restore, starts the container. [`publish.yml`](.github/workflows/publish.yml): builds, smoke-tests, and pushes the image to ECR on `v*` tags |
| Ops 4: Kubernetes | [`ops4/`](ops4/) | [`terraform/`](ops4/terraform/) and [`ansible/`](ops4/ansible/) install k3s; [`k8s/`](ops4/k8s/) deploys Minecraft with a persistent volume, ConfigMap, `LoadBalancer` service on 25565, a world backup CronJob, and an ECR token refresh job |
| Ops 5: Observability | [`ops5/`](ops5/) | [`helm/`](ops5/helm/) installs kube-prometheus-stack (30s scrape, 10 day / 2 GB retention); [`k8s/`](ops5/k8s/) holds the `mc-monitor` ServiceMonitor, Grafana dashboard, and alerts (unavailable deployment, crash-looping pod, high disk usage); [`ansible/`](ops5/ansible/) deploys it all |

The GitHub Actions workflow has to stay in `.github/workflows/` at the repo root; it builds from [`ops2/`](ops2/).

## Running it yourself

The full step-by-step setup lives in the runbook (link to be added). Before following it on your own fork, know that:

- Nothing works unchanged. Account-specific values (ECR registry, repo name, S3 bucket, image tag) are hardcoded in [`ops3/ansible/group_vars`](ops3/ansible/group_vars/minecraft.yml), [`ops4/ansible/group_vars`](ops4/ansible/group_vars/minecraft.yml), the Terraform `variables.tf` files, and [`ops4/k8s/`](ops4/k8s/). Search the repo for `339712777428` and `cs312-minsu-kim-mc-backups`.
- The image pipeline needs GitHub Actions secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and `ECR_REPO`. AWS Academy credentials are temporary, so refresh them whenever the Learner Lab restarts.
- The EC2 hosts use the Academy `LabInstanceProfile` for ECR and S3 access, so no AWS keys live on the servers.

## Teardown and cost

The EC2 instance bills while running. Stop it between sessions:

```bash
aws ec2 stop-instances --instance-ids <instance_id>    # pause (disk still billed)
terraform destroy                                      # remove everything
```

To remove only monitoring: `helm uninstall kube-prom -n monitoring && kubectl delete ns monitoring`.

Never commit AWS credentials. In Ops 4, `terraform.tfvars` and the live `inventory.ini` are gitignored; copy the `.example` files instead.
