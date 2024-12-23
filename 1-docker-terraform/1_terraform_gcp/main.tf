terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.1"
    }
  }
}

provider "google" {
  project = var.gcp.project
  region  = var.gcp.region
  #   ********************************************
  #   ************** Authentication **************
  #   ********************************************
  #   (1) Using a service account key file
  #   credentials = file("~/.config/gcloud/terraform.json")
  #   -------------------------------
  #   (2) Using environment variables
  #   We can create enviroment variable GOOGLE_CREDENTIALS which we create by running:
  #   export GOOGLE_CREDENTIALS=$(pwd)/keys/credentials.json
  #   When using environment variables, we don't need to specify the credentials 
  #   attribute in the provider block.
  #   -------------------------------
  #   (3) Using a terraform variable with reference to the credentials file
  #   The variable definition:
  #   variable "gcp_credentials" {
  #     description = "GCP credentials"
  #     type        = string
  #     default     = "./keys/credentials.json"
  #   }
  #   The usage block:
  #   provider "google" {
  #     ...
  #     credentials = file(var.gcp_credentials)
  #     ...
  #   }
  #   ********************************************
}

# Create a GCS bucket
resource "google_storage_bucket" "demo_bucket" {
  name          = var.gcp.storage.name
  location      = var.gcp.location
  storage_class = var.gcp.storage.storage_class
  force_destroy = true

  lifecycle_rule {
    condition {
      age = var.gcp.storage.lifecycle_rule.age # days
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1 # 1 day
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# Create a BigQuery dataset 
resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id    = var.gcp.bigquery.dataset_id
  friendly_name = var.gcp.bigquery.friendly_name
  description   = var.gcp.bigquery.description
  location      = var.gcp.location
}

# Create a Compute Engine VM instance
# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

# resource "google_compute_instance" "instance-20241223-105225" {
#   boot_disk {
#     auto_delete = true
#     device_name = "instance-20241223-105225"

#     initialize_params {
#       image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241219"
#       size  = 30
#       type  = "pd-balanced"
#     }

#     mode = "READ_WRITE"
#   }

#   can_ip_forward      = false
#   deletion_protection = false
#   enable_display      = false

#   labels = {
#     goog-ec-src = "vm_add-tf"
#   }

#   machine_type = "e2-standard-4"
#   name         = "instance-20241223-105225"

#   network_interface {
#     access_config {
#       network_tier = "PREMIUM"
#     }

#     queue_count = 0
#     stack_type  = "IPV4_ONLY"
#     subnetwork  = "projects/data-engineering-zoomcamp-2025/regions/europe-west1/subnetworks/default"
#   }

#   scheduling {
#     automatic_restart   = true
#     on_host_maintenance = "MIGRATE"
#     preemptible         = false
#     provisioning_model  = "STANDARD"
#   }

#   service_account {
#     email  = "235528431033-compute@developer.gserviceaccount.com"
#     scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
#   }

#   shielded_instance_config {
#     enable_integrity_monitoring = true
#     enable_secure_boot          = false
#     enable_vtpm                 = true
#   }

#   zone = "europe-west1-b"
# }
