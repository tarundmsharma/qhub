provider "google" {
  project = "qhub-deployments"
  region  = "us-central1"
  zone    = "us-central1-c"
}


module "registry-jupyterhub" {
  source = "github.com/quansight/qhub-terraform-modules//modules/gcp/registry?ref=release-0.3.11"
}


module "kubernetes" {
  source = "github.com/quansight/qhub-terraform-modules//modules/gcp/kubernetes?ref=release-0.3.11"

  name     = local.cluster_name
  location = var.region

  availability_zones = var.availability_zones

  additional_node_group_roles = [
    "roles/storage.objectViewer",
    "roles/storage.admin"
  ]

  additional_node_group_oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  node_groups = [

    {
      name          = "general"
      instance_type = "n1-standard-2"
      min_size      = 1
      max_size      = 1
    },

    {
      name          = "user"
      instance_type = "n1-standard-2"
      min_size      = 0
      max_size      = 2
    },

    {
      name          = "worker"
      instance_type = "n1-standard-2"
      min_size      = 0
      max_size      = 5
    },

  ]
}
