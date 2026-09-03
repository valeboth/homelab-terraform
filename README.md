# homelab-terraform

Terraform config for my home lab, which runs on a single Proxmox VE 9 node.

I built this for two reasons:

1. **Backup / disaster recovery.** If the node dies, I can rebuild the whole set of containers on a fresh Proxmox host by running `terraform apply` instead of clicking through the web UI 14 times.
2. **Learning Infrastructure as Code** and having something real to show.

The lab is a self-hosted media setup (the *arr apps + Plex) plus a few tools like AdGuard, Vaultwarden and Uptime Kuma. Everything runs in unprivileged LXC containers.

## How it works

I use the community [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

Instead of writing one block per container, I keep a small inventory in `locals.tf` and loop over it with a single `for_each` resource in `containers.tf`. Each entry only lists what actually differs between containers (CPU, RAM, disk, IP, DNS, etc.), so adding a new container is just one line in the map.

Things that are described in code:

- static IPs on `vmbr0` (Cloudflared is on DHCP)
- bind mount `/mnt/hdd/media -> /media` for the containers that need the media library (Radarr, Sonarr, Plex, qBittorrent, Bazarr)
- iGPU passthrough (`/dev/dri`) for Plex hardware transcoding
- boot order and start delays
- `nesting` / `keyctl` flags per container

## Files

| File | What it does |
| --- | --- |
| `versions.tf` | Terraform + provider version constraints |
| `providers.tf` | Proxmox provider setup |
| `variables.tf` | inputs and defaults (node, subnet, templates, storage) |
| `locals.tf` | the container inventory |
| `containers.tf` | the single `for_each` resource |
| `outputs.tf` | hostname -> IP map |
| `terraform.tfvars.example` | copy this to `terraform.tfvars` and fill it in |

## Auth

I don't use `root@pam`. I created a dedicated user and API token on Proxmox with only the privileges the provider needs:

```sh
pveum role add TerraformProv -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt"
pveum user add terraform@pve
pveum aclmod / -user terraform@pve -role TerraformProv
pveum user token add terraform@pve provider --privsep 0
```

The token and endpoint go in `terraform.tfvars`, which is gitignored, so no secrets end up in the repo.

## Usage

```sh
cp terraform.tfvars.example terraform.tfvars
# put your endpoint + token in terraform.tfvars

terraform init
terraform plan
terraform apply
```

To move the whole stack to a different subnet you only change one variable: `network_prefix`.

## Notes

- The state file is local and gitignored. In a real setup it would live in a remote backend (S3 + a lock table).
- Proxmox uses a self-signed cert, so the provider runs with `insecure = true`.
- This only provisions the containers themselves, not the apps inside them.
