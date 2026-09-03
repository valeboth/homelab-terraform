locals {
  adguard_dns = "${var.network_prefix}.135"

  templates = {
    debian = var.debian_template
    ubuntu = var.ubuntu_template
  }

  containers = {
    nginxproxymanager = { vm_id = 200, cores = 2, memory = 2048, swap = 512, disk = 6, ostype = "debian", ip = 138, dns = [local.adguard_dns], nesting = true, keyctl = true, order = null, up = null, media = false, devices = [] }
    adguard           = { vm_id = 201, cores = 1, memory = 512, swap = 512, disk = 2, ostype = "debian", ip = 135, dns = ["1.1.1.1"], nesting = false, keyctl = true, order = 1, up = null, media = false, devices = [] }
    radarr            = { vm_id = 202, cores = 2, memory = 1024, swap = 512, disk = 4, ostype = "debian", ip = 141, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 3, up = 10, media = true, devices = [] }
    sonarr            = { vm_id = 203, cores = 2, memory = 1024, swap = 512, disk = 4, ostype = "debian", ip = 142, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 3, up = 10, media = true, devices = [] }
    plex              = { vm_id = 204, cores = 2, memory = 2048, swap = 512, disk = 8, ostype = "ubuntu", ip = 139, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 2, up = 15, media = true, devices = [{ path = "/dev/dri/renderD128", gid = 993 }, { path = "/dev/dri/card0", gid = 44 }] }
    prowlarr          = { vm_id = 205, cores = 2, memory = 1536, swap = 512, disk = 4, ostype = "debian", ip = 140, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 3, up = 10, media = false, devices = [] }
    qbittorrent       = { vm_id = 206, cores = 2, memory = 2048, swap = 512, disk = 8, ostype = "debian", ip = 143, dns = [], nesting = true, keyctl = true, order = 2, up = 15, media = true, devices = [] }
    bazarr            = { vm_id = 207, cores = 2, memory = 2048, swap = 512, disk = 4, ostype = "debian", ip = 146, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 3, up = 10, media = true, devices = [] }
    vaultwarden       = { vm_id = 208, cores = 1, memory = 1024, swap = 512, disk = 6, ostype = "debian", ip = 137, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 4, up = 10, media = false, devices = [] }
    overseerr         = { vm_id = 209, cores = 1, memory = 1024, swap = 512, disk = 6, ostype = "debian", ip = 144, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 4, up = 10, media = false, devices = [] }
    maintainerr       = { vm_id = 210, cores = 1, memory = 1024, swap = 512, disk = 6, ostype = "debian", ip = 145, dns = [local.adguard_dns], nesting = true, keyctl = true, order = 4, up = 10, media = false, devices = [] }
    uptimekuma        = { vm_id = 211, cores = 1, memory = 1024, swap = 512, disk = 4, ostype = "debian", ip = 147, dns = [local.adguard_dns, "1.1.1.1"], nesting = true, keyctl = true, order = null, up = null, media = false, devices = [] }
    monitoring        = { vm_id = 212, cores = 2, memory = 2048, swap = 512, disk = 8, ostype = "debian", ip = 150, dns = [local.adguard_dns, "1.1.1.1"], nesting = true, keyctl = true, order = null, up = null, media = false, devices = [] }
    cloudflared       = { vm_id = 213, cores = 1, memory = 256, swap = 256, disk = 4, ostype = "debian", ip = null, dns = [], nesting = true, keyctl = false, order = null, up = null, media = false, devices = [] }
  }
}
