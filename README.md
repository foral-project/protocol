<div align="center">

# 📜 Foral Protocol

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![JSON Schema](https://img.shields.io/badge/JSON%20Schema-Draft%202020--12-green.svg)](https://json-schema.org/draft/2020-12/schema)
[![JSON-LD](https://img.shields.io/badge/JSON--LD-1.1-orange.svg)](https://www.w3.org/TR/json-ld11/)
[![Schemas Live](https://img.shields.io/badge/Schemas-Live%20↗-brightgreen)](https://foral-project.github.io/protocol/schemas/v1/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Active-success)](https://foral-project.github.io/protocol/)

Protocolo vendor-agnostic para governança de repositórios federados.

[Especificação](PROTOCOL.md) ·
[Schemas](https://foral-project.github.io/protocol/schemas/v1/) ·
[JSON-LD Contexts](https://foral-project.github.io/protocol/context/v1/) ·
[Templates](templates/)

</div>

---

## O que é

O Foral Protocol define **schemas**, **templates**, **contextos semânticos** e
**convenções de naming** que repositórios federados devem seguir.

O protocolo é a **constituição**. A [governance](https://github.com/foral-project/governance)
é o **judiciário** que aplica a constituição via CI gates e OPA policies.

> **Zero formatos inventados.** Cada artefato rastreia a um standard oficial (IETF, W3C, CNCF).

## Estrutura

```
schemas/v1/
├── catalog-info.schema.yaml          ← Schema do manifesto Backstage
└── federation-registry.schema.yaml   ← Schema do registry de federação

context/v1/
├── catalog.jsonld                    ← Contexto JSON-LD para manifesto
└── registry.jsonld                   ← Contexto JSON-LD para registry

templates/
├── application/                      ← Golden path: aplicação
└── infrastructure/                   ← Golden path: OpenTofu module
```

## URLs Live (GitHub Pages)

Todos os artefatos são servidos via HTTPS e consumidos automaticamente pelos workflows:

| Artefato | URL |
|---|---|
| Catalog Schema | [`schemas/v1/catalog-info.schema.yaml`](https://foral-project.github.io/protocol/schemas/v1/catalog-info.schema.yaml) |
| Registry Schema | [`schemas/v1/federation-registry.schema.yaml`](https://foral-project.github.io/protocol/schemas/v1/federation-registry.schema.yaml) |
| Catalog JSON-LD | [`context/v1/catalog.jsonld`](https://foral-project.github.io/protocol/context/v1/catalog.jsonld) |
| Registry JSON-LD | [`context/v1/registry.jsonld`](https://foral-project.github.io/protocol/context/v1/registry.jsonld) |
| Install Script | [`install.sh`](https://foral-project.github.io/protocol/install.sh) |

## Standards

| Artefato | Standard | Organização |
|---|---|---|
| Schemas | JSON Schema Draft 2020-12 | IETF |
| Contextos | JSON-LD 1.1 | W3C |
| Manifesto | Backstage catalog-info.yaml | CNCF |
| Naming | RFC 1123 DNS Labels | IETF |
| Versioning | SemVer 2.0.0 | semver.org |
| Commits | Conventional Commits 1.0.0 | conventionalcommits.org |
| Eventos | CloudEvents 1.0.3 | CNCF |
| Templates IaC | OpenTofu module structure | Linux Foundation |
| Licença | Apache-2.0 | OSI |

## Ecossistema

| Repo | Papel |
|---|---|
| 📜 **[protocol](https://github.com/foral-project/protocol)** | Schemas, templates, contexts (este repo) |
| ⚖️ **[governance](https://github.com/foral-project/governance)** | CI gates, OPA policies, federation registry |
| 🔧 **[cli](https://github.com/foral-project/cli)** | Validação e scaffold via terminal |
| 📦 **[template](https://github.com/foral-project/template)** | GitHub template para novos repos |

## Licença

[Apache-2.0](LICENSE) — SPDX-License-Identifier: Apache-2.0
