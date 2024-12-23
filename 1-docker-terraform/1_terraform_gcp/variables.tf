variable "gcp_credentials" {
  description = "GCP credentials"
  type        = string
  default     = "./keys/credentials.json"
}
variable "gcp" {
  description = "GCP configuration"
  type = object({
    project  = string
    location = string
    region   = string
    bigquery = object({
      dataset_id    = string
      friendly_name = string
      description   = string
    })
    storage = object({
      name        = string
      description = string
      lifecycle_rule = object({
        age = number
      })
      storage_class = string
    })
  })
  default = {
    project  = "data-engineering-zoomcamp-2025"
    location = "EU"
    region   = "europe-west1"
    bigquery = {
      dataset_id    = "demo_dataset"
      friendly_name = "demo_dataset"
      description   = "Demo dataset description"
    }
    storage = {
      name        = "tf-demo-bucket-data-engineering-zoomcamp-2025"
      description = "Demo bucket description"
      lifecycle_rule = {
        age = 30 # days
      }
      storage_class = "STANDARD"
    }
  }
}
