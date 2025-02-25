variable "user_name" {
  description = "IAM username"
  type        = string
}

variable "policy_arns" {
  description = "List of AWS managed policy ARNs to attach"
  type        = list(string)
}
