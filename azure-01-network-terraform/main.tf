terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

data "azurerm_resource_group" "network" {
  name = "rg-azsprint-network"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-azsprint"
  address_space       = ["10.20.0.0/16"]
  location            = data.azurerm_resource_group.network.location
  resource_group_name = data.azurerm_resource_group.network.name

  tags = {
    project = "azure-sprint"
  }
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = data.azurerm_resource_group.network.location
  resource_group_name = data.azurerm_resource_group.network.name

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    project = "azure-sprint"
  }
}

resource "azurerm_network_security_group" "data" {
  name                = "nsg-data"
  location            = data.azurerm_resource_group.network.location
  resource_group_name = data.azurerm_resource_group.network.name

  security_rule {
    name                       = "Allow-SQL-From-App"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.20.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    project = "azure-sprint"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

# Network Watcher

data "azurerm_network_watcher" "main" {
  name                = "NetworkWatcher_eastus"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_storage_account" "flowlogs" {
  name                     = "stazsprintflowlogs"
  resource_group_name      = data.azurerm_resource_group.network.name
  location                 = data.azurerm_resource_group.network.location
  account_tier             = "Standard"
  account_kind             = "StorageV2" # matches Microsoft's own validated example for this exact use case
  account_replication_type = "LRS"

  tags = {
    project = "azure-sprint"
  }
}

# VNet-level flow log — confirmed via Microsoft's official Terraform example for this exact
# scenario. Replaces per-NSG flow logs (no longer creatable since mid-2025); logs traffic
# across both subnets in the VNet in one place.
resource "azurerm_network_watcher_flow_log" "vnet" {
  network_watcher_name = data.azurerm_network_watcher.main.name
  resource_group_name  = data.azurerm_network_watcher.main.resource_group_name
  name                 = "flowlog-vnet-azsprint"

  target_resource_id = azurerm_virtual_network.main.id
  storage_account_id = azurerm_storage_account.flowlogs.id
  enabled            = true
  version            = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  tags = {
    project = "azure-sprint"
  }
}

# Azure Bastion (Developer SKU, free tier) — secure, browser-based RDP/SSH to VMs in this
# VNet without giving them a public IP or exposing port 3389/22 directly to the internet.
# Unlike the paid SKUs, Developer needs no dedicated subnet or public IP of its own.
resource "azurerm_bastion_host" "dev" {
  name                = "bastion-azsprint-dev"
  resource_group_name = data.azurerm_resource_group.network.name
  location            = data.azurerm_resource_group.network.location
  sku                 = "Developer"
  virtual_network_id  = azurerm_virtual_network.main.id

  tags = {
    project = "azure-sprint"
  }
}
