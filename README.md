# Foral Protocol

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![JSON Schema](https://img.shields.io/badge/JSON%20Schema-Draft%202020--12-green.svg)](https://json-schema.org/draft/2020-12/schema)
[![JSON-LD](https://img.shields.io/badge/JSON--LD-1.1-orange.svg)](https://www.w3.org/TR/json-ld11/)

[Specification](PROTOCOL.md) · [Schemas](https://foral-project.github.io/protocol/schemas/v1/) · [JSON-LD Contexts](https://foral-project.github.io/protocol/context/v1/) · [Templates](templates/)

---

Defines the schemas, templates, semantic contexts, and naming conventions that federated repositories must follow. All artifacts are served via GitHub Pages and consumed by CI workflows at runtime.

> Every artifact traces back to an industry standard (IETF, W3C, CNCF). No custom formats.

## Structure

```
schemas/v1/
├── catalog-info.schema.yaml        ← Backstage manifest schema
└── federation-registry.schema.yaml ← Federation registry schema

context/v1/
├── catalog.jsonld                  ← JSON-LD context for manifests
└── registry.jsonld                 ← JSON-LD context for registry

templates/
├── application/                    ← Golden path: application
└── infrastructure/                 ← Golden path: OpenTofu module
```

## Live URLs (GitHub Pages)

All artifacts are served via HTTPS:

| Artifact | URL |
|---|---|
| Catalog Schema | [`schemas/v1/catalog-info.schema.yaml`](https://foral-project.github.io/protocol/schemas/v1/catalog-info.schema.yaml) |
| Registry Schema | [`schemas/v1/federation-registry.schema.yaml`](https://foral-project.github.io/protocol/schemas/v1/federation-registry.schema.yaml) |
| Catalog JSON-LD | [`context/v1/catalog.jsonld`](https://foral-project.github.io/protocol/context/v1/catalog.jsonld) |
| Registry JSON-LD | [`context/v1/registry.jsonld`](https://foral-project.github.io/protocol/context/v1/registry.jsonld) |
| Install Script | [`install.sh`](https://foral-project.github.io/protocol/install.sh) |

## Standards

| Artifact | Standard | Org |
|---|---|---|
| Schemas | JSON Schema Draft 2020-12 | IETF |
| Contexts | JSON-LD 1.1 | W3C |
| Manifest | Backstage catalog-info.yaml | CNCF |
| Naming | RFC 1123 DNS Labels | IETF |
| Versioning | SemVer 2.0.0 | semver.org |
| Commits | Conventional Commits 1.0.0 | conventionalcommits.org |
| Events | CloudEvents 1.0.3 | CNCF |
| IaC Templates | OpenTofu module structure | Linux Foundation |

## Ecosystem

| Repo | Role |
|---|---|
| [protocol](https://github.com/foral-project/protocol) | Schemas, templates, contexts (this repo) |
| [governance](https://github.com/foral-project/governance) | CI workflows, OPA policies, federation registry |
| [cli](https://github.com/foral-project/cli) | Validation and scaffolding CLI |
| [template](https://github.com/foral-project/template) | GitHub template for new projects |

## License

[Apache-2.0](LICENSE) — SPDX-License-Identifier: Apache-2.0