#Proxmox info
proxmox_host         = "10.10.10.101:8006"
proxmox_node         = "proxmox"
proxmox_api_user     = "root@pam"
proxmox_api_password = "somepassword"

# Nomad client Packer image information
ssh_password     = "somepassword"
nomad_ver        = "1.9.0"
nomad_config   = "nomad.pkrtpl.hcl"
create_nfs_mount = true          # if set to false, nfs_server & nfs_shares are ignored. This exists if you want to use nfs shares for your bind mount volumes for your workloads which makes it easy for workloads to move to different nodes without using static host volumes. It's a temporary measure until dynamic host volumes are released. https://github.com/hashicorp/nomad/issues/15489
nfs_server       = "10.10.10.10" #change this to your nfs server if using
nfs_shares       = ["/volume1/share", "/volume2/anothershare"]

# Uncomment to enable
#enterprise = true 
#consul_install = true 
#consul_ver = "1.19.2"
#consul_config  = "consul.pkrtpl.hcl"
