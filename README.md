# Proxmox Nomad Client Packer Template
This Packer template will build a Debian 12 image template on Proxmox with a Nomad client and Consul client(optional), Docker, and Podman installed. A default configuration file has been provided, but you can customize it to your liking and it will be uploaded into the image during the build process.

#### Task Drivers
Below are the task drivers enabled on the image, but you are free to customize the template files to fit your needs.
- Docker
- Podman 
- Raw_exec

## Instructions
### Requirements
1. A functioning Nomad 1.6+ server and client. This can be the same node. I run my primary Nomad server and client node on a Synology NAS and this tool builds the clients on another server with Proxmox.
2. Packer 1.9+
2. Proxmox 7.x
3. Internet Connectivity (for downloading binaries and ISO)
4. Consul server (If using Consul integration)

### How to Run
1. `git clone https://github.com/awanaut/proxmox-packer-nomad-client.git && cd proxmox-packer-nomad-client`
2. Edit `variables.auto.pkrvars.hcl` to fit your environment. I have included some defaults to assist and an explanation below.
3. Edit `nomad.pkrtpl.hcl` to fit your environment. Visit [Nomad docs for more information](https://developer.hashicorp.com/nomad/docs/configuration/client) on configuration options.
4. If using Enterprise binary, add license key to `license.hclic.tpl`
5. If using Consul, edit `consul.pkrtpl.hcl` to fit your environment.
5. Run `packer build -force .`

## Required Variables
Variables that have no defaults that cant be assumed about your setup.

| Variable | Type | Default | Description | 
| --- | --- | --- | --- |
| proxmox_host | String | | Proxmox host API IP/Port Ie. 10.1.1.101:8006 |
| proxmox_node | String | |  Friendly node name in Promox to deploy image on |
| proxmox_api_user | String | root | User with API permissions| 
| proxmox_api_password | String| | Password of API user |
| ssh_password | String | | root password for OS image |

## Optional Variables
Variables that have reasonable defaults but may need to be customized for your environment.

### Proxmox Variables
| Variable | Type | Default | Description | 
| --- | --- | --- | --- |
| iso_storage_pool | String | local | Storage pool for downloaded Debian ISO | 
| cloudinit_storage_pool | String | local-lvm | Cloud init drive location |
| hostname | String | nomad-template | hostname and template name |
| vm_id | String | 9999 | A vm id must be set for the provider so the template can be overwritten if rerunning Packer |


### OS Image Variables
| Variable | Type |  Default | Description | 
| --- | --- | --- | --- |
| cores | Integer | 1 | CPU cores of image | 
| cpu_type | String | kvm64 | CPU type. Dont change this unless you know what you're doing. |
| memory | Integer | 2048 | Memory of the image |
| disk_size | Integer | 32 | Disk size in GB, I wouldn't go lower than 16. 32 or higher is recommended. | 
| disk_format | String | raw | Disk format |
| network_vlan | Integer | 0 | VLAN tag |
| os_user | String | nomad | Debian user to create |
| os_password | String | nomad | Password of `os_user` |

### Nomad Variables
If you're new to Nomad, I would leave the defaults. Otherwise, you can specify a few variables to allow touch-less joining of your clients to your cluster.

| Variable | Type |  Default | Description | 
| --- | --- | --- | --- |
| nomad_ver | String |  1.6.1 | Version number |
| create_nfs_mount | bool | false | Set to true if you want to mount to an nfs share. `nfs_shares` & `nfs_server` must be specified. |
| nfs_shares | array(String) | | An array of nfs shares to add to your clients node and expose within Nomad. Ie. ["/volume1/share1", "/volume2/share2"] |
| nfs_server | String | | nfs server to mount your shares on. Ensure the os_user you specified and/or the subnet you are deploying to has appropriate permissions. |


### Optional Additions
| Variable | Type |  Default | Description | 
| --- | --- | --- | --- |
| consul_install | bool | false | If true, install the Consul binary in client mode and copy over the config file. There is currently no dynamic templating, so ensure the `consul.pkrtpl.hcl` file is accurate to your environment. |
| enterprise | bool | false | If true, downloads the enterprise binary and copies over the license file. Ensure the correct license is in the `license.hclic.tpl` file or else Nomad will not start |