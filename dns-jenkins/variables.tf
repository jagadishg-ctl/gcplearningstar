################################################################################
## Project Configuration
################################################################################

variable "project_id" {
  type        = string
  description = "GCP project ID where DNS resources will be created"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

################################################################################
## DNS Configuration
################################################################################

variable "jenkins_lb_ip" {
  type        = string
  description = "Internal IP address of Jenkins load balancer"
  default     = "10.10.10.50"
}

variable "dns_zone_name" {
  type        = string
  description = "Private DNS zone name (must end with a dot)"
  default     = "gcphome.store."
}

variable "jenkins_host_label" {
  type        = string
  description = "Hostname label for Jenkins in the private DNS zone"
  default     = "jenkins"
}
