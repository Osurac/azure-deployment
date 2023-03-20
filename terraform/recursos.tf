# Se crea un recurso de grupo de recursos con nombre y ubicación específicos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name  # nombre de la red virtual
  address_space       = ["10.0.0.0/16"]   # espacio de direccionamiento de la red virtual
  location            = azurerm_resource_group.rg.location  # ubicacion de los recursos en la red virtual
  resource_group_name = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado a la red virtual
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name  # nombre del subred
  resource_group_name  = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado al subred
  virtual_network_name = azurerm_virtual_network.vnet.name  # nombre de la red virtual asociada al subred
  address_prefixes     = ["10.0.2.0/24"]  # espacio de direccionamiento del subred
}

resource "azurerm_public_ip" "pip" {
  name                = "osuraccp2ppip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "mnic" {
  name                = "mnic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "vnic" {
  name                = "vnic"  # nombre de la interfaz de red
  location            = azurerm_resource_group.rg.location  # ubicacion de los recursos en la interfaz de red
  resource_group_name = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado a la interfaz de red

  ip_configuration {
    name                          = "internal"  # nombre de la configuracion de IP
    subnet_id                     = azurerm_subnet.subnet.id  # ID del subred asociado a la interfaz de red
    private_ip_address_allocation = "Dynamic"  # asignacion de direccionamiento de IP privada
  }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "tls_webserver"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.mnic.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "asocv" {
  network_interface_id      = azurerm_network_interface.vnic.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}