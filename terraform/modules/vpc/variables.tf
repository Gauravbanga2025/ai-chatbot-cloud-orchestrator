variable "network_name" {
  type        = string
  description = "Name of the custom VPC network"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-south1"
}
