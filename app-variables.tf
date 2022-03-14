
#############################
## Application - Variables ##
#############################

variable "aks-vnet" {
  type        = string
  description = "existing aks vnet"
  sensitive   = true
}

variable "aks-vnet-subnet" {
  type        = string
  description = "existing aks vnet"
  sensitive   = true
}

variable "aks-vnet-resource-group" {
  type        = string
  description = "existing aks vnet resource group"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "North Europe"
}

variable "postgres-resource-group" {
  type        = string
  description = "resource group where postgres components would be created"
}