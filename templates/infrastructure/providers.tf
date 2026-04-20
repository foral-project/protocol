# Provider configuration.
# Standard: OpenTofu/HashiCorp — providers.tf isolado do main.tf.
#
# Os providers são declarados sem credenciais hardcoded.
# Autenticação via variáveis de ambiente ou instance principal.

provider "oci" {
  region = var.region
  # auth via: OCI_TENANCY_OCID, OCI_USER_OCID, OCI_FINGERPRINT,
  #           OCI_PRIVATE_KEY_PATH (env vars)
}
