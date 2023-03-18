variable "resource_group_name" {
    default = "rg-casopractico2"
    description = "RG name in Azure"
}

variable "acr_name" {
    default = "acrcasopractico2"
    description = "ACR name in Azure"
}

variable "location" {
    default = "uksouth"
    description = "Resources location in Azure"
}

variable "network_name" {
    default = "vnet1"
    description = "Network name vm in Azure"
}

variable "subnet_name" {
    default = "subnet1"
    description = "Subnet name vm in Azure"
}