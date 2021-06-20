variable "name" {
  type    = string
  default = "qhub-deployments"
}

variable "environment" {
  type    = string
  default = "dev"
}


variable "region" {
  type    = string
  default = "us-central1"
}

variable "availability_zones" {
  description = "GCP availability zones within region"
  type        = list(string)
  default     = ["us-central1-c"]
}
# jupyterhub
variable "endpoint" {
  description = "Jupyterhub endpoint"
  type        = string
  default     = "qhub.dev"
}

variable "jupyterhub-image" {
  description = "Jupyterhub user image"
  type = object({
    name = string
    tag  = string
  })
  default = {
    name = "quansight/qhub-jupyterhub"
    tag  = "v0.3.11"
  }
}

variable "jupyterlab-image" {
  description = "Jupyterlab user image"
  type = object({
    name = string
    tag  = string
  })
  default = {
    name = "quansight/qhub-jupyterlab"
    tag  = "v0.3.11"
  }
}

variable "dask-worker-image" {
  description = "Dask worker image"
  type = object({
    name = string
    tag  = string
  })
  default = {
    name = "quansight/qhub-dask-worker"
    tag  = "v0.3.11"
  }
}

variable "dask-gateway-image" {
  description = "Dask worker image"
  type = object({
    name = string
    tag  = string
  })
  default = {
    name = "quansight/qhub-dask-gateway"
    tag  = "v0.3.11"
  }
}


