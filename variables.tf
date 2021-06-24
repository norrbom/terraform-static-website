variable "bucket" {
  type        = string
  description = "Name of the s3 bucket"
  default     = null
}
variable "content_path" {
  type        = string
  description = "The path to the content directory"
  default     = "./"
}

variable "acl" {
  type        = string
  description = "Bucket ACL policy"
  default     = "private"
}

variable "policy" {
  type = map(any)
  default = {
    "Effect"    = "Allow"
    "Principal" = "*"
    "Action"    = "s3:GetObject"
  }
}

variable "policy_allowed_source_ip" {
  type        = list(any)
  description = "Constrain access to a list of source IP"
  default     = []
}
