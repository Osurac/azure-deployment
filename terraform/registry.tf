##############ACR#################

# Se crea un registro de contenedor de Azure con nombre, ubicación y configuraciones específicas
resource "azurerm_container_registry" "example" {
  name                     = var.acr_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  sku                      = "Basic"
  admin_enabled            = true
}

# Se define una salida que muestra la dirección del servidor de inicio de sesión de ACR
output "admin_password" {
  value = azurerm_container_registry.acr.admin_password
  description = "The object ID of the user"
sensitive = true
}