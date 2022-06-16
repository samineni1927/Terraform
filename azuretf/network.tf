// Enter all the info required to build a vpc and subnet in azure

// step1 create a resource group

resource "azurerm_resource_group" "azure_rg" {
    name                    = "tfazure"
    location                = "East US"
}

// step2 create a virtual network

resource "azurerm_virtual_network" "azure_vn" {
    name                    = "samvn"
    location                = azurerm_resource_group.azure_rg.location
    resource_group_name     = azurerm_resource_group.azure_rg.name
    address_space           = var.network_cidr
}

// step3 create subnets

resource "azurerm_subnet" "subnets" {
    count                   = length(var.subnet_names) 
    name                    = var.subnet_names[count.index]
    resource_group_name     = azurerm_resource_group.azure_rg.name
    virtual_network_name    = azurerm_virtual_network.azure_vn.name
    address_prefixes        = [cidrsubnet(var.network_cidr[0],8,count.index)]
}