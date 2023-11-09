# Create Bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_service_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.224/27"]
}

# Azure Bastion Public IP
resource "azurerm_public_ip" "bastion_service_publicip" {
  name                = var.bastion_service_publicip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Bastion Service Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion_configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_service_publicip.id
  }
}