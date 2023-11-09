# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = var.environment
  }
}

# Create virtual network if it doesn't exist
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = var.environment
  }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}

# Create Load Balancer public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.linux_public_ip_alb_fe
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"

  tags = {
    environment = var.environment
  }
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
        environment = var.environment
  }
}

# Create network interface for master
resource "azurerm_network_interface" "nic_master" {
  name                = var.network_interface_master
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.ip_configuration_name_nic_master
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
   }

  tags = {
     environment = var.environment
  }
}

# Create network interface for node1
resource "azurerm_network_interface" "nic_node1" {
  name                = var.network_interface_node1
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.ip_configuration_name_nic_node1
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
   }

  tags = {
     environment = var.environment
  }
}

# Create network interface for node2
resource "azurerm_network_interface" "nic_node2" {
  name                = var.network_interface_node2
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.ip_configuration_name_nic_node2
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
   }

  tags = {
     environment = var.environment
  }
}

# Connect the security group to the network interface of master
resource "azurerm_network_interface_security_group_association" "association_master" {
  network_interface_id      = azurerm_network_interface.nic_master.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Connect the security group to the network interface of node1
resource "azurerm_network_interface_security_group_association" "association_node1" {
  network_interface_id      = azurerm_network_interface.nic_node1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Connect the security group to the network interface of node2
resource "azurerm_network_interface_security_group_association" "association_node2" {
  network_interface_id      = azurerm_network_interface.nic_node2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Create virtual machine master
resource "azurerm_linux_virtual_machine" "master" {
  name                  = var.linux_virtual_machine_master
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_master.id]
  size                  = var.vm_size_master
  admin_username        = var.vm_username
  admin_password        = var.vm_password
  computer_name         = var.vm_hostname_master
  disable_password_authentication = false

  os_disk  {
    name                 = "OS_disk_${var.vm_hostname_master}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
     environment = var.environment
  }
}

# Create virtual machine node1
resource "azurerm_linux_virtual_machine" "node1" {
  name                  = var.linux_virtual_machine_node1
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_node1.id]
  size                  = var.vm_size_node1
  admin_username        = var.vm_username
  admin_password        = var.vm_password
  computer_name         = var.vm_hostname_node1
  disable_password_authentication = false

  os_disk  {
    name                 = "OS_disk_${var.vm_hostname_node1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
     environment = var.environment
  }
}


# Create virtual machine node2
resource "azurerm_linux_virtual_machine" "node2" {
  name                  = var.linux_virtual_machine_node2
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_node2.id]
  size                  = var.vm_size_node2
  admin_username        = var.vm_username
  admin_password        = var.vm_password
  computer_name         = var.vm_hostname_node2
  disable_password_authentication = false

  os_disk  {
    name                 = "OS_disk_${var.vm_hostname_node2}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
     environment = var.environment
  }
}

# Create Azure Standard Load Balancer
resource "azurerm_lb" "kube_lb" {
  name                = var.load_balancer_name 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Create Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "kube_lb_backend_address_pool" {
  name                = var.backend_address_pool_name
  loadbalancer_id     = azurerm_lb.kube_lb.id
}

# Create Load Balancer Health Probe
resource "azurerm_lb_probe" "health_probe_workernode" {
  name                = var.health_probe_name 
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.kube_lb.id
 }

# Create Load Balancer Rule for inbound port 80
resource "azurerm_lb_rule" "port_80" {
  loadbalancer_id                = azurerm_lb.kube_lb.id
  name                           = var.port_80_load_balancer_rule_name 
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.kube_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe_workernode.id
}

# Create Load Balancer Rule for inbound port 443
resource "azurerm_lb_rule" "port_443" {
  loadbalancer_id                = azurerm_lb.kube_lb.id
  name                           = var.port_443_load_balancer_rule_name 
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = var.frontend_ip_configuration
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.kube_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe_workernode.id
}


# Backend virtual machine node1 association with backend pool
resource "azurerm_network_interface_backend_address_pool_association" "be_pool_node1_associate" {
  network_interface_id    = azurerm_network_interface.nic_node1.id
  ip_configuration_name   = azurerm_network_interface.nic_node1.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.kube_lb_backend_address_pool.id
}

# Backend virtual machine node2 association with backend pool
resource "azurerm_network_interface_backend_address_pool_association" "be_pool_node2_associate" {
  network_interface_id    = azurerm_network_interface.nic_node2.id
  ip_configuration_name   = azurerm_network_interface.nic_node2.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.kube_lb_backend_address_pool.id
}
