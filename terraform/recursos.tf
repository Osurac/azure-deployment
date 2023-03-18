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

resource "azurerm_network_interface" "nic" {
  name                = "vnic"  # nombre de la interfaz de red
  location            = azurerm_resource_group.rg.location  # ubicacion de los recursos en la interfaz de red
  resource_group_name = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado a la interfaz de red

  ip_configuration {
    name                          = "internal"  # nombre de la configuracion de IP
    subnet_id                     = azurerm_subnet.subnet.id  # ID del subred asociado a la interfaz de red
    private_ip_address_allocation = "Dynamic"  # asignacion de direccionamiento de IP privada
  }
}