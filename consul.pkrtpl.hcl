datacenter = "dc1"
data_dir = "/opt/consul" #Do not change. Referenced in provisioning script.
verify_incoming        = false
verify_outgoing        = false
verify_server_hostname = false
performance {
  raft_multiplier = 1
}
bind_addr   = "{{ GetPrivateInterfaces | include \"network\" \"10.0.0.0/24\" | attr \"address\" }}"
client_addr = "127.0.0.1"
server      = false
retry_join  = ["10.0.0.101"]
