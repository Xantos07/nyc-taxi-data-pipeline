variable "credentials" {
  description = "my credentials"
  default = "./keys/my-creds.json"
}

variable "project" {
  description = "Project"
  default     = "project-38f9ae16-bea2-4d91-8e8"
}

variable "region" {
  description = "Project region"
  default     = "europe-west1"
}

variable "location" {
  description = "Project location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "project-38f9ae16-bea2-4d91-8e8-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage class"
  default     = "STANDARD"
}