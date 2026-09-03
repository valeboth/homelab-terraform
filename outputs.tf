output "container_addresses" {
  value = {
    for name, c in local.containers :
    name => c.ip == null ? "dhcp" : "${var.network_prefix}.${c.ip}"
  }
}
