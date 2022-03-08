terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project     = var.instance_project
  region      = var.instance_region
}

variable "instance_region" {
  default = "europe-north1"
}

variable "instance_project" {
  default = "not-specified"
}
