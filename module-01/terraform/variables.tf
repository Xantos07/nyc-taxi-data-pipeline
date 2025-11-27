variable "credentials" {
  description = "Path to GCP credentials JSON file"
  type        = string
}

variable "project" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  type        = string
}

variable "gcs_bucket_name" {
  description = "bucket name"
  type        = string
}

variable "gcs_storage_class" {
  description = "bucket storage class"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
}
