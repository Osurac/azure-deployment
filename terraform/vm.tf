##############VM#################
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm1"  # nombre de la maquina virtual
  resource_group_name = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado a la maquina virtual
  location            = azurerm_resource_group.rg.location  # ubicacion de los recursos en la maquina virtual
  size                = "Standard_F2"  # tamaño de la maquina virtual
  admin_username      = "azureuser"  # nombre de usuario del administrador de la maquina virtual
  network_interface_ids = [
    azurerm_network_interface.nic.id,  # ID de la interfaz de red asociada a la maquina virtual
  ]

  admin_ssh_key {
    username   = "azureuser"  # nombre de usuario para autenticacion SSH
    public_key = file("~/.ssh/id_rsa.pub")  # clave publica SSH
  }

  os_disk {
    caching              = "ReadWrite"  # configuracion de cache de disco
    storage_account_type = "Standard_LRS"  # tipo de almacenamiento de disco
  }

  source_image_reference {
    publisher = "Canonical"  # publicador de la imagen de SO de la maquina virtual
    offer     = "UbuntuServer"  # oferta de la imagen de SO de la maquina virtual
    sku       = "16.04-LTS"  # SKU de la imagen de SO de la maquina virtual
    version   = "latest"  # version de la imagen de SO de la maquina virtual
  }
}
