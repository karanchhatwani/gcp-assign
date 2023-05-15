variable "project_id" {
  default  = "nimble-unison-386200"
}

variable "region" {
  description = "The region where the cluster will be created."
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where the cluster will be created."
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  default     = "my-cluster"
}

variable "node_count" {
  description = "The number of nodes in the cluster."
  default     = 1
}

variable "machine_type" {
  description = "The machine type of the nodes."
  default     = "n1-standard-1"
}
