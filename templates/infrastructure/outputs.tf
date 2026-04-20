# Outputs do módulo de infraestrutura.
# Standard: OpenTofu/HashiCorp — snake_case para nomes de output.

output "project_name" {
  description = "Nome do projeto provisionado."
  value       = var.project_name
}

output "environment" {
  description = "Ambiente de deploy ativo."
  value       = var.environment
}

output "region" {
  description = "Região do provider cloud."
  value       = var.region
}
