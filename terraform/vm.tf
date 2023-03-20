##############VM#################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm1"  # nombre de la maquina virtual
  resource_group_name = azurerm_resource_group.rg.name  # nombre del grupo de recursos asociado a la maquina virtual
  location            = azurerm_resource_group.rg.location  # ubicacion de los recursos en la maquina virtual
  size                = "Standard_F2"  # tamaño de la maquina virtual
  admin_username      = "azureuser"  # nombre de usuario del administrador de la maquina virtual

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.mnic.id,
    azurerm_network_interface.vnic.id,
  ]

  connection {
    type        = "ssh"
    user        = "azureuser"  # usuario SSH
    private_key = file("~/.ssh/id_rsa")  # clave privada SSH
    host        = self.public_ip_address  # direccion IP publica de la maquina virtual
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get install software-properties-common -y",
      "sudo add-apt-repository -y ppa:projectatomic/ppa",
      "sudo apt-get install podman -y",
      "sudo apt-get install python3-passlib",
    ]
  }
  
  os_disk {
    caching              = "ReadWrite"  # configuracion de cache de disco
    storage_account_type = "Standard_LRS"  # tipo de almacenamiento de disco
  }

  source_image_reference {
    publisher = "Canonical"  # publicador de la imagen de SO de la maquina virtual
    offer     = "UbuntuServer"  # oferta de la imagen de SO de la maquina virtual
    sku       = "18.04-LTS"  # SKU de la imagen de SO de la maquina virtual
    version   = "latest"  # version de la imagen de SO de la maquina virtual
  }
}