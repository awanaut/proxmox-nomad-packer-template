data_dir   = "/opt/nomad/data" #Do not change. Referenced in debian.pkr.hcl
bind_addr  = "0.0.0.0"
datacenter = "dc1"


client {
  enabled = true
  template { disable_file_sandbox = true } #I enable this in my homelab so i can render template files from outside the alloc dir. Probably not a good idea for prod.
  node_pool = "default" #change this if youre using node pools

  server_join {
    retry_join = ["10.0.0.10"] #Change this to your nomad server
    retry_max = 3
  }
}
acl {
  enabled = false
}

plugin "docker" {
  config {
    allow_privileged = true
    volumes {
      # required for bind mounting host directories
      enabled = true
    }
    allow_caps = ["all"] # 'all' is fine for lab, so specify exact caps for production for security reasons
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "nomad-driver-podman" {
	config {
		volumes {
			enabled = true
		}
	}
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
