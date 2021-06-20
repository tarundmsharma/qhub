locals {
  additional_tags = {
    Project     = var.name
    Owner       = "terraform"
    Environment = var.environment
  }

  cluster_name = "${var.name}-${var.environment}"

  node_groups = {
    general = {
      key   = "cloud.google.com/gke-nodepool"
      value = "general"
    }

    user = {
      key   = "cloud.google.com/gke-nodepool"
      value = "user"
    }

    worker = {
      key   = "cloud.google.com/gke-nodepool"
      value = "worker"
    }
  }
}
