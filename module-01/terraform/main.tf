terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.12.0"
    }
  }
}
provider "google" {
  project = "project-38f9ae16-bea2-4d91-8e8"
  region  = "europe-west1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "project-38f9ae16-bea2-4d91-8e8-terra-bucket"
  location      = "europe-west1"
  force_destroy = true

  uniform_bucket_level_access = true
  
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}