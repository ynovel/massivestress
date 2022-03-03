resource "digitalocean_ssh_key" "runner" {
  name       = "runner"
  public_key = file(var.provisioning_ssh_public_key_path)
}

variable "provisioning_ssh_private_key_path" {
  default = "../../keys/provisioning_key"
}

variable "provisioning_ssh_public_key_path" {
  default = "../../keys/provisioning_key.pub"
}
