#-----------------------------
#general variables
#-----------------------------
variable "aws-region" {
  type        = string
  default     = "eu-central-1"
  description = "Variable for AWS region"
}
#-----------------------------
#variables for network
#-----------------------------
variable "cidr-block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Variable for VPC CIDR block"
}

variable "public-subnet-cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private-subnet-cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs-eu-central-1" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

#-----------------------------
#variables for database
#-----------------------------
variable "db-password" {
  type        = string
  sensitive   = true
  description = "Database master user password"
}
variable "db-username" {
  type        = string
  sensitive   = true
  description = "Database master user"
}
