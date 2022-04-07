provider "azurerm" {
  subscription_id = "c11c3c9e-5237-40f6-9099-d0efce1aeb01"
  features {
  }
}

resource "azurerm_resource_group" "Lucas_vm_rg" {
  name     = var.resource_group_name
  location = var.location

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_account" "lucas_vm_sa" {
  name                     = "${var.prefix}sa"
  resource_group_name      = azurerm_resource_group.lucas_vm_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
resource "azurerm_virtual_network" "lucas_vm_vnet" {
  name                = var.virtual_network_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.lucas_vm_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}_subnet"
  virtual_network_name = azurerm_virtual_network.lucas_vm_vnet.name
  resource_group_name  = azurerm_resource_group.lucas_vm_rg.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_public_ip" "lucas_vm_pip" {
  name                = "${var.prefix}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.lucas_vm_rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.hostname
}

resource "azurerm_network_security_group" "lucas_vm_sg" {
  name                = "${var.prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.lucas_vm_rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "lucas_vm_nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.lucas_vm_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lucas_vm_pip.id
  }
}


resource "azurerm_virtual_machine" "lucas_vm_site" {
  name                = "${var.hostname}-site"
  location            = var.location
  resource_group_name = azurerm_resource_group.lucas_vm_rg.name
  vm_size             = var.vm_size

  network_interface_ids         = ["${azurerm_network_interface.lucas_vm_nic.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.hostname}_osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My first website using terraform provisioner</center></h1>' > index.html",
      "echo '<h1><center>Lucas Carvalho</center></h1>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
   
  }
}

