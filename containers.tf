resource "proxmox_virtual_environment_container" "lxc" {
  for_each = local.containers

  node_name     = var.target_node
  vm_id         = each.value.vm_id
  unprivileged  = true
  start_on_boot = true
  started       = true

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory
    swap      = each.value.swap
  }

  disk {
    datastore_id = var.datastore_id
    size         = each.value.disk
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  operating_system {
    template_file_id = local.templates[each.value.ostype]
    type             = each.value.ostype
  }

  features {
    nesting = each.value.nesting
    keyctl  = each.value.keyctl
  }

  initialization {
    hostname = each.key

    ip_config {
      ipv4 {
        address = each.value.ip == null ? "dhcp" : "${var.network_prefix}.${each.value.ip}/24"
        gateway = each.value.ip == null ? null : "${var.network_prefix}.1"
      }
    }

    dynamic "dns" {
      for_each = length(each.value.dns) > 0 ? [1] : []
      content {
        servers = each.value.dns
      }
    }
  }

  dynamic "startup" {
    for_each = each.value.order == null ? [] : [1]
    content {
      order    = each.value.order
      up_delay = each.value.up
    }
  }

  dynamic "mount_point" {
    for_each = each.value.media ? [1] : []
    content {
      volume = var.media_mount_host
      path   = "/media"
    }
  }

  dynamic "device_passthrough" {
    for_each = each.value.devices
    content {
      path = device_passthrough.value.path
      gid  = device_passthrough.value.gid
    }
  }
}
