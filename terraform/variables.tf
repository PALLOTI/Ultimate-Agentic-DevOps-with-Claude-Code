variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name, used to name and tag resources."
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Deployment environment (e.g. production, staging)."
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name for the site. Leave empty to use the CloudFront domain."
  type        = string
  default     = ""
}
