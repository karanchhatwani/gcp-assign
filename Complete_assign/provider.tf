provider "google" {
  region = "us-central1"
  zone   = "us-central1-a"
  credentials = file("./nimble-unison-386200-0ecea84cd92d.json")
  project = "nimble-unison-386200"
}