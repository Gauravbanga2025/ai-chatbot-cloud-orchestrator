resource "google_compute_network" "custom_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "${var.network_name}-subnet"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
  ip_cidr_range = "10.10.0.0/20"

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.30.0.0/20"
  }
}

output "network_name" {
  value = google_compute_network.custom_vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.gke_subnet.name
}
