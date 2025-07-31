# Packer Configuration

This directory contains Packer configurations for building base VM images on Proxmox.

## Prerequisites

- Packer 1.11+ installed
- Access to Proxmox VE cluster
- Ansible installed (for provisioning)

## Important: Packer 1.11+ Plugin Management

Starting with Packer 1.11, plugins must be installed using `packer init`. The automatic plugin discovery has been removed.

### Initialize Packer Plugins

Before building images, you must initialize the required plugins:

```bash
# For base image builds
cd packer/base
packer init .

# For base-clone builds
cd packer/base-clone
packer init .
```

This will download and install the required plugins:
- `hashicorp/proxmox` (>= 1.1.0)
- `hashicorp/ansible` (~> 1)

### Building Images

After initializing plugins, you can build images:

```bash
# Build base image with QEMU
packer build -only=qemu.base .

# Build base image with Proxmox-ISO
packer build -only=proxmox-iso.base .

# Build with specific variables
packer build -var-file=custom.pkrvars.hcl .
```

## Directory Structure

- `base/` - Base Debian image configuration
  - `main.pkr.hcl` - Main Packer configuration
  - `variables.pkr.hcl` - Variable definitions
  - `http/` - Preseed files for automated installation
- `base-clone/` - Clone-based image builds

## Plugin SHA256SUM Files

Packer 1.11+ requires SHA256SUM files for all plugins. These are automatically created when using `packer init`. Do not manually install plugins without their checksums.

## Troubleshooting

If you encounter plugin loading issues:

1. Ensure you've run `packer init` in the build directory
2. Check that plugin files have corresponding `.SHA256SUM` files
3. Remove any manually installed plugins from:
   - Current directory
   - Alongside Packer binary
   - `PACKER_PLUGIN_PATH` directory

For more information, see the [Packer 1.11 upgrade guide](https://developer.hashicorp.com/packer/docs/upgrade/v1_11).