resource "digitalocean_droplet" "runner" {
  count = var.instance_count
  image = "ubuntu-20-04-x64"
  name = "runner"
  region = var.instance_region
  size = var.instance_type
  ssh_keys = [
    digitalocean_ssh_key.runner.fingerprint
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"

    private_key = file(var.provisioning_ssh_private_key_path)
    timeout = "2m"
  }

  provisioner "file" {
    content = templatefile("../script/install_dependencies.tpl.sh", {})
    destination = "install_dependencies.sh"
  }

  provisioner "file" {
    content = templatefile("../script/resources.tpl.sh", {
      "is_remote" = var.runner_resources_mode_is_remote
      "resources_url" = var.runner_resources_url
    })
    destination = "resources.sh"
  }

  provisioner "file" {
    source = "../../resources"
    destination = "/tmp"
  }

  provisioner "file" {
    content = templatefile("../script/runner_bombardier.tpl.sh", {
      "connections_per_resource" = var.runner_bombardier_connections_per_resource
      "duration" = var.runner_bombardier_duration
    })
    destination = "runner_bombardier.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "/bin/sh install_dependencies.sh",
      "/bin/sh resources.sh",
      "/bin/bash runner_bombardier.sh",
    ]
  }
}

variable "instance_count" {
  default = 1
}

variable "instance_region" {
  default = "fra1"
}

variable "instance_type" {
  default = "s-1vcpu-1gb"
}
