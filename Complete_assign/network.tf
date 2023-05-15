resource "google_compute_network" "vpc" {
  name                    = "newvpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = true
}

resource "google_compute_global_address" "private_ip_block" {
  name         = "private-ip-block"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.vpc.name
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh-enabled"]
}