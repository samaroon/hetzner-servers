variable "hcloud_token" {
  description = "Hetzner Cloud API token — set via TF_VAR_hcloud_token or terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Hetzner Cloud region (hel1, nbg1, fsn1, ash, hil)"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type. cax11=ARM64 2vCPU/4GB, cpx21=x86 3vCPU/4GB, cax21=ARM64 4vCPU/8GB, cpx31=x86 4vCPU/8GB"
  type        = string
  default     = "cax11"
}

variable "image" {
  description = "OS image for the server"
  type        = string
  default     = "ubuntu-24.04"
}

# ── Credentials ────────────────────────────────────────────────────────────────

variable "ssh_public_key" {
  description = "SSH public key content (the actual key string, not a file path). Set via TF_VAR_ssh_public_key."
  type        = string
  sensitive   = true
}

variable "username" {
  description = "Admin user to create on the server"
  type        = string
}

variable "full_name" {
  description = "Full name for the admin user (GECOS field)"
  type        = string
  default     = ""
}

variable "password" {
  description = "Password for the admin user. Not required during destroy."
  type        = string
  sensitive   = true
}
