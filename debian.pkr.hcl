packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  mounts = replace(join(", ", var.nfs_shares), ",", "")
}

source "proxmox-iso" "debian-12" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_user
  password                 = var.proxmox_api_password

  template_description = "Nomad client running on Debian 12. Built on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  node                 = var.proxmox_node
  network_adapters {
    bridge   = "vmbr0"
    firewall = false
    model    = "virtio"
    vlan_tag = var.network_vlan
  }
  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    io_thread    = true
    storage_pool = var.disk_storage_pool
    type         = "scsi"
  }
  scsi_controller = "virtio-scsi-single"

  #iso_file       = var.iso_file
  iso_url          = var.iso_url
  iso_checksum     = "sha256:${var.checksum}"
  iso_storage_pool = var.iso_storage_pool
  #http_directory = "((env "NOMAD_ALLOC_DIR" ))"
  http_content = {
    "/preseed.cfg" = templatefile("./preseed.pkrtpl.cfg", {
      USERNAME = "${var.os_user}",
      PASSWORD = "${var.os_password}"
    })
  }
  // http_port_max = ((env "NOMAD_PORT_http" ))
  // http_port_min = ((env "NOMAD_PORT_http" ))
  boot_wait    = "10s"
  boot_command = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  unmount_iso  = true

  cloud_init              = true
  cloud_init_storage_pool = var.cloudinit_storage_pool

  vm_name  = "nomad-client-template-debian12"
  cpu_type = var.cpu_type
  vm_id    = var.vm_id
  os       = "l26"
  memory   = var.memory
  cores    = var.cores
  sockets  = "1"

  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_timeout  = "30m"
}

build {
  sources = ["source.proxmox-iso.debian-12"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "file" {
    destination = "/tmp/nomad.hcl"
    source      = "./${var.nomad_config}"
  }

  provisioner "file" {
    destination = "/tmp/consul.hcl"
    source      = "./${var.consul_config}"
  }

  provisioner "file" {
    destination = "/tmp/license.hclic"
    source      = "./${var.license}"
  }

  provisioner "file" {
    destination = "/tmp/nomad.service"
    source      = "./nomad.service.pkrtpl"
  }

  provisioner "shell" {
    script            = "./post.sh"
    pause_before      = "60s"
    expect_disconnect = true
    timeout           = "30m"
    environment_vars = [
      "NOMAD_VERSION=${var.nomad_ver}",
      "NFS_SERVER=${var.nfs_server}",
      "MOUNT=${local.mounts}",
      "OS_USER=${var.os_user}",
      "ENTERPRISE=${var.enterprise}",
      "CONSUL_INSTALL=${var.consul_install}",
      "CREATE_NFS_MOUNT=${var.create_nfs_mount}"
    ]
  }

  provisioner "shell" {
    inline = ["systemctl enable nomad"]
  }

}
