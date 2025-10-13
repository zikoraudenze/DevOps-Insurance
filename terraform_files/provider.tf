provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  scopes      = ["https://www.googleapis.com/auth/cloud-platform"]
}