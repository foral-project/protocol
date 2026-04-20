# Variáveis de entrada do módulo de infraestrutura.
# Standard: OpenTofu/HashiCorp — snake_case para nomes de variáveis.

variable "project_name" {
  description = "Nome do projeto. Usado como prefixo em recursos cloud (RFC 1123 label)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.project_name))
    error_message = "project_name deve ser um DNS label válido (RFC 1123): lowercase, hyphens, sem underscores."
  }
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser: dev, staging ou prod."
  }
}

variable "region" {
  description = "Região do provider cloud."
  type        = string
  default     = "sa-saopaulo-1"
}
