provider "google" {
  project = "qhub-deployments"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "terraform-state" {
  source = "github.com/quansight/qhub-terraform-modules//modules/gcp/terraform-state?ref=release-0.3.11"

  name     = "qhub-deployments-dev"
  location = "us-central1"
}

