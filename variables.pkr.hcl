variable "hostname" {
  type    = string
  default = "nomad-template"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso"
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}
variable "checksum" {
  type    = string
  default = "8fde79cfc6b20a696200fc5c15219cf6d721e8feb367e9e0e33a79d1cb68fa83"
}

variable "cloudinit_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cores" {
  type    = string
  default = "1"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "32G"
}

variable "disk_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "ssh_username" {
  type    = string
  default = "root"
}
variable "ssh_password" {
  type    = string
  default = "somepassword"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "vm_id" {
  type    = string
  default = "9999"
}

variable "nomad_ver" {
  type = string
}

variable "create_nfs_mount" {
  type = bool
}

variable "nfs_server" {
  type = string
}

variable "nfs_shares" {
  type = list(string)
}

variable "os_user" {
  type    = string
  default = "nomad"
}

variable "os_password" {
  type    = string
  default = "nomad"
}

variable "enterprise" {
  type    = bool
  default = false
}

variable "consul_install" {
  type    = bool
  default = false
}

variable "license" {
  type    = string
  default = "license.hclic.tpl"
}

variable "consul_config" {
  type    = string
  default = "consul.pkrtpl.hcl"
}

variable "consul_ver" {
  type = string
  default = "1.19.2"
}
variable "nomad_config" {
  type    = string
  default = "nomad.pkrtpl.hcl"
}