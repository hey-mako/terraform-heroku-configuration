variable "api_key" {
  description = "Heroku API token"
}

variable "config_vars" {
  default     = []
  description = "Configuration variables for the application"
  type        = "list"
}

variable "email" {
  description = "Email to be notified by Heroku"
}

variable "region" {
  default     = "us"
  description = "The region that the application should be deployed in"
}
