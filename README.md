# Foral Protocol

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![JSON Schema: Draft 2020-12](https://img.shields.io/badge/JSON%20Schema-Draft%202020--12-green.svg)](https://json-schema.org/draft/2020-12/schema)
[![JSON-LD: 1.1](https://img.shields.io/badge/JSON--LD-1.1-orange.svg)](https://www.w3.org/TR/json-ld11/)

Protocolo vendor-agnostic para governança de repositórios federados.

Inspirado nas **Cartas de Foral** medievais portuguesas — documentos que concediam
autonomia a municípios dentro de limites constitucionais definidos pela Coroa.

## O que é

O Foral Protocol define **schemas**, **templates**, **contextos semânticos** e
**convenções de naming** que repositórios federados devem seguir.

O protocolo é a **constituição**. A [governance](https://github.com/foral-project/governance)
é o **judiciário** que aplica a constituição via CI gates e OPA policies.

## Especificação

📜 **[PROTOCOL.md](PROTOCOL.md)** — Especificação completa (formato RFC-style)

## Estrutura

```
.
├── schemas/v1/
│   ├── catalog-info.schema.yaml          ← Schema do manifesto Backstage
│   └── federation-registry.schema.yaml   ← Schema do registry de federação
├── templates/
│   ├── infrastructure/                   ← Golden path: OpenTofu module
│   └── application/                      ← Golden path: applicação
├── context/v1/
│   ├── catalog.jsonld                    ← Contexto JSON-LD para manifesto
│   └── registry.jsonld                   ← Contexto JSON-LD para registry
├── catalog-info.yaml                     ← Self-describing manifest
├── PROTOCOL.md                           ← Especificação
├── LICENSE                               ← Apache-2.0
└── README.md
```

## Standards

Zero formatos inventados. Cada artefato rastreia a um standard oficial:

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

## Como usar

1. Copie um template de `templates/` para seu novo repositório
2. Preencha o `catalog-info.yaml` com os dados do seu componente
3. Registre seu repositório no `federation-registry.yaml` da governance instance
4. O CI da governance validará automaticamente seu manifesto

## Ecossistema

| Repo | Papel |
|---|---|
| **[protocol](https://github.com/foral-project/protocol)** | Schemas, templates, contexts (este repo) |
| **[governance](https://github.com/foral-project/governance)** | CI gates, OPA policies, federation registry |

## Licença

[Apache-2.0](LICENSE) — SPDX-License-Identifier: Apache-2.0
