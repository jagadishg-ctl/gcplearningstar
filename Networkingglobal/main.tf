# Simple VM instance in Networkingglobal
resource "google_compute_instance" "networkingglobal_vm" {
  project      = google_project.networkingglobal.project_id
  name         = "networkingglobal-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_hub.id
    subnetwork = google_compute_subnetwork.subnet_vpn.id
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Hello from Networkingglobal VM!" > /var/tmp/hello.txt
  EOF
}
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create new GCP project
resource "google_project" "networkingglobal" {
  name            = "Networkingglobal"
  project_id      = var.new_project_id
  billing_account = var.billing_account
}

# Enable required Google Cloud APIs
resource "google_project_service" "compute_api" {
  project = google_project.networkingglobal.project_id
  service = "compute.googleapis.com"
  
  disable_on_destroy = false
}

# Create the VPC network named "vpc-networkingbackend"
resource "google_compute_network" "vpc_hub" {
  project                 = google_project.networkingglobal.project_id
  name                    = "vpc-networkingbackend"
  auto_create_subnetworks = false
  
  depends_on = [google_project_service.compute_api]
}

# Create subnet named "subnet-vpn" with CIDR 20.20.0.0/16
resource "google_compute_subnetwork" "subnet_vpn" {
  project = google_project.networkingglobal.project_id

  name = "subnet-vpn"

  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_hub.id

  private_ip_google_access = true
}

# Firewall rule to allow IAP (Identity-Aware Proxy) access
resource "google_compute_firewall" "allow_iap" {
  project = google_project.networkingglobal.project_id
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc_hub.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["35.235.240.0/20"]
  
  description = "Allow SSH access from Google Cloud IAP"
}

# Firewall rule to allow Firezone/WireGuard UDP traffic
resource "google_compute_firewall" "allow_firezone_udp" {
  project = google_project.networkingglobal.project_id
  name    = "allow-firezone-udp"
  network = google_compute_network.vpc_hub.name
  
  allow {
    protocol = "udp"
    ports    = ["51820"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  
  description = "Allow WireGuard VPN traffic on standard port 51820"
}

# VPC Peering from Hub to Spoke
resource "google_compute_network_peering" "hub_to_spoke" {
  name         = "vpc-networkingbackend-to-vpc-jenkins-private"
  network      = google_compute_network.vpc_hub.self_link
  peer_network = "projects/core-it-infra-prod/global/networks/vpc-jenkins-private"
  
  export_custom_routes = true
  import_custom_routes = true
}
