variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default     = "your-resource-group-name"
}

variable "admin_username" {
  description = "Admin username for VM"
  default     = "slcdf-admin"
}

variable "admin_password" {
  description = "Admin password for VM"
  default     = "testpassword" # Note: Avoid setting default passwords. This is just an example.
}

variable "windowsVersion" {
  description = "Windows version for VM"
  default     = "2019-Datacenter"
}
