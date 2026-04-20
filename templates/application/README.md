# CHANGE-ME

> Descrição do repositório de aplicação.

## Início Rápido

```bash
# Clone
git clone https://github.com/foral-project/CHANGE-ME.git
cd CHANGE-ME

# Setup
make setup

# Validação
make check
```

## Estrutura

```
.
├── catalog-info.yaml   ← Manifesto Backstage (obrigatório)
├── README.md
└── src/                ← Código-fonte da aplicação
```

## Governança

Este repositório é um membro federado do [Foral Protocol](https://github.com/foral-project/protocol).

- **Manifesto:** `catalog-info.yaml` validado contra JSON Schema + OPA policies
- **Naming:** RFC 1123 DNS Labels
- **Commits:** Conventional Commits 1.0.0
- **Versioning:** SemVer 2.0.0

## Licença

[Apache-2.0](LICENSE)
