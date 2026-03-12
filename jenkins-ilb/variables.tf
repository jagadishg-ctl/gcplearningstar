################################################################################
## Project Configuration
################################################################################

variable "project_id" {
  type        = string
  description = "GCP project ID where resources will be created"
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone where Jenkins server is deployed"
  default     = "us-central1-a"
}

variable "jenkins_vm_name" {
  type        = string
  description = "Name of the Jenkins VM instance used as ILB backend"
  default     = "gcp-jenkins"
}

variable "ssl_private_key" {
  type        = string
  description = "PEM-encoded private key for the Jenkins SSL certificate"
  sensitive   = true
}

variable "ssl_certificate" {
  type        = string
  description = "PEM-encoded certificate chain for Jenkins SSL"
  sensitive   = true
}
