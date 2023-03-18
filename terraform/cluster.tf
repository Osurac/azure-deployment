##############CLUSTER#################

# Crea un clúster de AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "myakscluster"

  # Versión de Kubernetes
  kubernetes_version = "1.21.4"

  # Configuración del pool de nodos
  node_pool {
    name            = "default"
    vm_size         = "Standard_DS2_v2"
    orchestrator_version = azurerm_kubernetes_cluster.aks.kubernetes_version
    availability_zones = ["1", "2", "3"]
    node_count      = 3
  }

  # Configuración del servicio de red de Kubernetes
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
    pod_cidr       = "10.244.0.0/16"
  }
}

# Exporta las credenciales del clúster para que puedan ser usadas por kubectl
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}