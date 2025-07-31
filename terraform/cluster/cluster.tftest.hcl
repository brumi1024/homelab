# Test configuration for the cluster module
# This test validates the basic VM provisioning functionality

variables {
  proxmox_ip        = "https://test-proxmox.local:8006"
  proxmox_api_token = "test-user@pam!test-token=test-secret"
  ssh_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... test@example.com"
  
  # Test with minimal server configuration
  server_count      = 1
  server_ip         = "10.0.0.10"
  
  # Test with minimal client configuration  
  client_count      = 1
  client_ip         = "10.0.0.20"
}

# Test that server VMs are created correctly
run "server_vm_creation" {
  command = plan

  assert {
    condition     = module.server[0].vm.name == "server-0"
    error_message = "Server VM name should be 'server-0'"
  }

  assert {
    condition     = module.server[0].vm.ipv4_addresses[0][0] == "10.0.0.10/24"
    error_message = "Server VM IP should be '10.0.0.10/24'"
  }
}

# Test that client VMs are created correctly
run "client_vm_creation" {
  command = plan

  assert {
    condition     = module.client[0].vm.name == "client-0"
    error_message = "Client VM name should be 'client-0'"
  }

  assert {
    condition     = module.client[0].vm.ipv4_addresses[0][0] == "10.0.0.20/24"
    error_message = "Client VM IP should be '10.0.0.20/24'"
  }
}

# Test multiple VMs scenario
run "multiple_vms" {
  variables {
    server_count = 3
    client_count = 2
  }

  command = plan

  assert {
    condition     = length(module.server) == 3
    error_message = "Should create 3 server VMs"
  }

  assert {
    condition     = length(module.client) == 2
    error_message = "Should create 2 client VMs"
  }
}

# Test VM configuration
run "vm_configuration" {
  command = plan

  assert {
    condition     = module.server[0].vm.cpu.cores == 4
    error_message = "Server VM should have 4 CPU cores"
  }

  assert {
    condition     = module.server[0].vm.memory.dedicated == 8192
    error_message = "Server VM should have 8GB RAM"
  }

  assert {
    condition     = module.client[0].vm.cpu.cores == 2
    error_message = "Client VM should have 2 CPU cores"
  }

  assert {
    condition     = module.client[0].vm.memory.dedicated == 4096
    error_message = "Client VM should have 4GB RAM"
  }
}