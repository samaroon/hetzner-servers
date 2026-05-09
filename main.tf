terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.61.0"
    }
  }

  # Backend is configured at runtime via -backend-config=backend.hcl
  # See: https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration
  backend "s3" {}
}

provider "hcloud" {
  token = var.hcloud_token
}

locals {
  server_name = "${var.username}-${var.server_type}-${var.region}"
}

# ── SSH Key ────────────────────────────────────────────────────────────────────
resource "hcloud_ssh_key" "server_ssh_key" {
  name       = local.server_name
  public_key = var.ssh_public_key

  lifecycle {
    ignore_changes = [public_key]
  }
}

# ── Server ─────────────────────────────────────────────────────────────────────
resource "hcloud_server" "dev_server" {
  name        = local.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.region

  ssh_keys = [hcloud_ssh_key.server_ssh_key.id]

  # All provisioning via cloud-init — no remote-exec.
  # Logs: /var/log/cloud-init-output.log  |  /var/log/provision.log
  user_data = templatefile("${path.module}/cloud-init.yaml", {
    ssh_public_key = var.ssh_public_key
    full_name      = var.full_name
    username       = var.username
    password       = var.password
  })
}

# ── Outputs ────────────────────────────────────────────────────────────────────
output "ipv4_address" {
  value = hcloud_server.dev_server.ipv4_address
}

output "ssh_command" {
  value = "ssh ${var.username}@${hcloud_server.dev_server.ipv4_address}"
}

output "watch_logs" {
  value = "ssh root@${hcloud_server.dev_server.ipv4_address} 'tail -f /var/log/provision.log'"
}
