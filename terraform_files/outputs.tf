output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_location" {
  value = google_container_cluster.gke_cluster.location
}

output "project_id" {
  value = var.project_id
}

output "endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}