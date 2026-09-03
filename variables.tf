variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "target_node" {
  type    = string
  default = "vale"
}

variable "datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_prefix" {
  type    = string
  default = "192.168.1"
}

variable "media_mount_host" {
  type    = string
  default = "/mnt/hdd/media"
}

variable "debian_template" {
  type    = string
  default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "ubuntu_template" {
  type    = string
  default = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}
