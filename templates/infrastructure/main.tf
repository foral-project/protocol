# Golden Path Template — Infrastructure (OpenTofu)
#
# Ponto de entrada do módulo de infraestrutura.
# Standard: OpenTofu/HashiCorp module structure (main.tf + variables.tf + outputs.tf)
#
# Uso: copie esta pasta para um novo repositório de infraestrutura
# e preencha os valores em variables.tf.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    # Provedores declarados sem namespace hardcoded
    # para compatibilidade OpenTofu + Terraform.
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }

  # Backend de estado remoto. Ajuste conforme o provider.
  # backend "s3" {}
}
