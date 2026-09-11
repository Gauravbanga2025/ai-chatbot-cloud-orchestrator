terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source       = "../../modules/vpc"
  network_name = "ai-orchestrator-vpc"
  region       = var.region
}

module "gke" {
  source       = "../../modules/gke"
  project_id   = var.project_id
  region       = var.region
  cluster_name = "ai-orchestrator-gke"
  network_name = module.vpc.network_name
  subnet_name  = module.vpc.subnet_name
}
EOF

# Create variables.tf
cat << 'EOF' > variables.tf
variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default     = "biopulse-cloud-prod"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-south1"
}
