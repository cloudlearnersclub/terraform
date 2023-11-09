variable "resource_group_name" {
  type        = string
  description = "RG"
}

variable "resource_group_location" {
  type        = string
  description = "Location"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET"
}

variable "subnet_name" {
  type        = string
  description = "Subnet"
}

variable "linux_public_ip_alb_fe" {
  type        = string
  description = "LoadBalancer PIP"
}

variable "load_balancer_name" {
  type        = string
  description = "LoadBalancer Name"
}

variable "frontend_ip_configuration" {
  type        = string
  description = "LoadBalancer FE Config"
}

variable "backend_address_pool_name" {
  type        = string
  description = "LoadBalancer BE Pool Name"
}

variable "health_probe_name" {
  type        = string
  description = "LoadBalancer BE Health Probe"
}


variable "port_80_load_balancer_rule_name" {
  type        = string
  description = "LoadBalancer Port 80 Rule"
}

variable "port_443_load_balancer_rule_name" {
  type        = string
  description = "LoadBalancer Port 443 Rule"
}

variable "network_security_group_name" {
  type        = string
  description = "NSG Name"
}


variable "network_interface_master" {
  type        = string
  description = "NIC Name Master VM"
}

variable "network_interface_node1" {
  type        = string
  description = "NIC Name Node1 VM"
}

variable "network_interface_node2" {
  type        = string
  description = "NIC Name Node2 VM"
}

variable "ip_configuration_name_nic_master" {
  type        = string
  description = "NIC IP Config Master VM"
}


variable "ip_configuration_name_nic_node1" {
  type        = string
  description = "NIC IP Config Master Node1"
}

variable "ip_configuration_name_nic_node2" {
  type        = string
  description = "NIC IP Config Master Node2"
}

variable "linux_virtual_machine_master" {
  type        = string
  description = "Master VM Name in Portal"
}


variable "linux_virtual_machine_node1" {
  type        = string
  description = "Node1 VM Name in Portal"
}


variable "linux_virtual_machine_node2" {
  type        = string
  description = "Node2 VM Name in Portal"
}


variable "environment" {
  type        = string
  description = "Tag for production Environment"
}

variable "vm_size_master" {
  type        = string
  description = "Master VM Size"
}


variable "vm_size_node1" {
  type        = string
  description = "Node1 VM Size"
}

variable "vm_size_node2" {
  type        = string
  description = "Node2 VM Size"
}

variable "vm_username" {
  type        = string
  description = "Default Username"
}


variable "vm_hostname_master" {
  type        = string
  description = "Master VM Hostname"
}

variable "vm_hostname_node1" {
  type        = string
  description = "Node1 VM Hostname"
}

variable "vm_hostname_node2" {
  type        = string
  description = "Node2 VM Hostname"
}

variable "vm_password" {
  type        = string
  description = "Default User Password"
}

variable "bastion_service_subnet_name" {
  type        = string
  description = "Bastion Subnet Name"
}

variable "bastion_service_publicip" {
  type        = string
  description = "Bastion Public IP"
}


variable "bastion_host_name" {
  type        = string
  description = "Bastion Host Name"
}





