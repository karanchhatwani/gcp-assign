# Define a health check
resource "google_compute_health_check" "default" {
  name               = "http-health-check"
  check_interval_sec = 5
  timeout_sec        = 3
  tcp_health_check {
    port = 80
  }
}

# Define the instance group
resource "google_compute_instance_group" "private_instance_group" {
  name        = "private-instance-group"
  description = "Instance group for private instances"
  zone        = "us-central1-a"

  network_interface {
    subnetwork = google_compute_subnetwork.regional_subnet.self_link
    access_config {
      nat_ip = google_compute_address.lb_ip.address
    }
  }

  named_port {
    name = "http"
    port = 80
  }

  instance_template {
    name = "private-instance-template"
    machine_type = var.machine_type

    disk {
      boot = true
      initialize_params {
        image = "ubuntu-minimal-2004-focal-v20230601"
      }
    }

    metadata_startup_script = file("startup.sh")

    network_interface {
      subnetwork = google_compute_subnetwork.regional_subnet.self_link
    }
  }
}

# Define the backend service
resource "google_compute_backend_service" "default" {
  name        = "backend-service"
  description = "Backend service for the load balancer"
  port_name   = "http"
  protocol    = "HTTP"
  backend {
    group = google_compute_instance_group.private_instance_group.self_link
  }
  health_checks = [google_compute_health_check.default.self_link]
}

# Define the forwarding rule
resource "google_compute_forwarding_rule" "default" {
  name                = "forwarding-rule"
  region              = "us-central1"
  ip_protocol         = "TCP"
  port_range          = "80"
  load_balancing_scheme = "EXTERNAL"
  target              = google_compute_backend_service.default.self_link
}

# Define a static IP for the load balancer
resource "google_compute_address" "lb_ip" {
  name   = "lb-ip"
  region = "us-central1"
}

# Output the IP address of the load balancer
output "load_balancer_ip" {
  value = google_compute_address.lb_ip.address
}
