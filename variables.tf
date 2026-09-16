variable "subscription_id" { type = string }
variable "resource_group_name" { type = string }
variable "user_id" {
  type        = string
  description = "ID apprenant : nom + numero du Resource Group"
}
variable "location" {
  type    = string
  default = "francecentral"
}
variable "environment" {
  type    = string
  default = "dev"
}
