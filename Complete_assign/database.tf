resource "google_sql_database" "main" {
  name     = "main"
  instance = google_sql_database_instance.main_primary.name
}
resource "google_sql_database_instance" "main_primary" {
  name             = "main-primary"
  database_version = "POSTGRES_13"
  depends_on       = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 10  # 10 GB is the smallest disk size
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.self_link
    }
  }
}
resource "google_sql_user" "db_user" {
  name     = "Karan"
  instance = google_sql_database_instance.main_primary.name
  password = "Karan"
}