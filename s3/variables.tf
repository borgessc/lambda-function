variable "region" {
  description = "Where the resources will be created"
  type        = string 
}

variable "environment" {
  description = "Describe the environment that will be used to deploy a resource"
  type        = string
}

variable "enable_mfa_delete" {
  description  = "Boolean to enable or disable MFA delete for S3 Bucket"
  type         = bool
  default      = false 

}

variable "allowed_accounts_read_access" {
  type    = list(string)
  default = []
  description = "A list of AWS accounts ID to provide read access to terraform state file"

}

variable "filename" {
  default = "function.zip"
  description = "Lambda zip file name"
  
}

variable "app-version" {
  description = "Version of new Lambda Function"
  default = "v1.0.0"

}