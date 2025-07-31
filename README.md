# Homelab

This repository contains infrastructure-as-code for the automated deployment and
configuration, and management of a Hashicorp (Nomad + Consul + Vault) cluster on
Proxmox.

## Overview

This project aims to provision a full Hashicorp cluster in a **semi-automated**
manner. It utilizes Packer, Ansible and Terraform:

1. Packer creates base Proxmox VM templates from cloud images and ISOs
2. Terraform provisions cluster nodes by cloning existing VM templates
3. Ansible installs and configures Vault, Consul, Nomad on cluster nodes

It comprises minimally of one server and one client node with no high
availability (HA). The nodes run Vault, Consul and Nomad as a cluster.

To support HA, the setup can be further expanded to at least three server nodes
and multiple client nodes hosted on a Proxmox cluster, spanning multiple
physical machines.

## Folder Structure

```bash
.
├── ansible/
│   ├── roles
│   ├── playbooks
│   ├── inventory    # inventory files
│   └── goss         # goss config
├── bin              # custom scripts
├── packer/
│   ├── base         # VM template from ISO
│   └── base-clone   # VM template from existing template
└── terraform/
    ├── cluster      # config for cluster
    ├── dev          # config where I test changes
    ├── minio        # config for Minio buckets
    ├── modules      # tf modules
    ├── nomad        # nomad jobs
    ├── postgres     # config for Postgres DB users
    ├── proxmox      # config for Proxmox accounts
    └── vault        # config for Vault
```

## Limitations

- Manual Vault unseal on reboot
- Inter-job dependencies are [not supported](https://github.com/hashicorp/nomad/issues/545) in Nomad
- Vault agent is run as root

See [issues]() for more information.

## Acknowledgements

- [CGamesPlay/infra](https://github.com/CGamesPlay/infra)
- [assareh/homelab](https://github.com/assareh/home-lab)
- [RealOrangeOne/infrastructure](https://github.com/RealOrangeOne/infrastructure)
