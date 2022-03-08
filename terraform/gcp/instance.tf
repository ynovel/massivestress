resource "google_compute_address" "runner" {
  count = var.instance_count
  name = "runner-address-${count.index}"
  address_type = ""
}

resource "google_compute_instance" "runner" {
  count = var.instance_count
  name = "runner-${count.index}"
  machine_type = var.instance_type
  zone = var.instance_az
  boot_disk {
    initialize_params {
      #image = "ubuntu-os-cloud/ubuntu-2004-lts" #image list: https://cloud.google.com/compute/docs/images/os-details
      image = "debian-cloud/debian-11"
      #size = 50
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.runner[count.index].address
    }
  }

  metadata = {
    ssh-keys = "root:${file(var.provisioning_ssh_public_key_path)}"
  }

  #metadata_startup_script = ""

#  service_account {
#    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#  }

  connection {
    host = self.network_interface.0.access_config.0.nat_ip
    #host = self.hostname
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

  provisioner "file" {
    source = "../script/show_resources_availability.sh"
    destination = "show_resources_availability.sh"
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

variable "instance_az" {
  default = "europe-north1-b"
}

variable "instance_type" {
  default = "e2-micro" #2 vCPU, 1GB
}

output "instance_ip" {
  value = google_compute_address.runner.*.address
}
