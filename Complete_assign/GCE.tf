resource "google_compute_subnetwork" "regional_subnet" {
  name   = "subnet-5"
  region = "us-central1"
  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.vpc.self_link
}
resource "google_compute_instance" "private_instance" {
  zone = "us-central1-a"
  name         = "private-instancenew3"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2004-focal-v20230427"
    }
  }
  

  network_interface {
    subnetwork = google_compute_subnetwork.regional_subnet.self_link
  }

  metadata_startup_script = "${file("startup.sh")}"
}
