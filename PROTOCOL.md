# Foral Protocol Specification v0.1.0

> **Status:** Draft  
> **License:** Apache-2.0 (SPDX-License-Identifier: Apache-2.0)  
> **Authors:** Foral Project Contributors  
> **Latest:** <https://github.com/foral-project/protocol>

---

## 1. Introduction

O Foral Protocol define um conjunto de schemas, templates, contextos semânticos e
convenções de naming para governança de repositórios federados.

O protocolo é **vendor-agnostic**: não contém nenhuma referência a GitHub Actions,
GitHub Apps, ou qualquer plataforma específica de CI/CD. Implementações de
enforcement (CI gates, policy engines) pertencem à camada de **governance**, não
ao protocolo.

### 1.1 Motivação

Equipes que gerenciam múltiplos repositórios enfrentam fragmentação de padrões:
cada repo inventa seu próprio formato de manifesto, naming, e estrutura de pastas.
O Foral Protocol resolve isso definindo um contrato federado — análogo às Cartas
de Foral medievais portuguesas, que concediam autonomia a municípios dentro de
limites constitucionais definidos pela Coroa.

### 1.2 Design Principles

1. **Zero formatos inventados.** Cada artefato do protocolo rastreia a um standard
   oficial ou de facto da indústria (IETF, W3C, CNCF, IEEE).
2. **Vendor-agnostic.** O protocolo é implementável em qualquer plataforma Git.
3. **Federação constitucional.** Membros são autônomos dentro dos limites do protocolo.
4. **Validação estática.** Toda compliance é verificável sem runtime (JSON Schema + OPA).

### 1.3 Relationship to Governance

```
┌──────────────────────────────────────────────┐
│                  Protocol                     │
│  (vendor-agnostic: schemas, templates,        │
│   contexts, naming rules, event vocabulary)   │
└────────────────────┬─────────────────────────┘
                     │ consumes
┌────────────────────▼─────────────────────────┐
│                 Governance                    │
│  (vendor-specific: CI gates, OPA policies,    │
│   federation registry, GitHub workflows)      │
└──────────────────────────────────────────────┘
```

O protocol é a **constituição**. A governance é o **judiciário** que aplica a constituição.

---

## 2. Terminology

Os termos a seguir são usados com significado preciso nesta especificação:

| Termo | Definição |
|---|---|
| **Protocol** | Este documento e os artefatos associados (schemas, templates, contexts). |
| **Governance** | Instância que aplica o protocolo via CI, policies e registry. |
| **Member** | Repositório federado que declara conformidade com o protocolo via `catalog-info.yaml`. |
| **Registry** | Arquivo `federation-registry.yaml` que lista todos os members de uma governance instance. |
| **Archetype** | Classificação funcional de um membro (`protocol`, `governance`, `infrastructure`, `application`, `bot`). |
| **Manifest** | Arquivo `catalog-info.yaml` na raiz de cada repositório. |
| **DNS Label** | String conforme RFC 1123, §2.1: `[a-z0-9]([a-z0-9-]*[a-z0-9])?`, max 63 caracteres. |
| **Golden Path Template** | Estrutura de diretórios pré-definida para bootstrapping de novos membros. |

### 2.1 Key Words

As palavras-chave "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHOULD", "MAY" nesta
especificação seguem a interpretação descrita na [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

---

## 3. Conformance Requirements

Um repositório é **conformant** com o Foral Protocol se:

1. **MUST** conter um arquivo `catalog-info.yaml` na raiz que valide contra o
   [Catalog Info Schema](#6-schema-definitions).
2. **MUST** incluir o campo `@context` apontando para o JSON-LD context do protocolo.
3. **MUST** usar um `metadata.name` que seja um DNS label válido (RFC 1123).
4. **MUST** declarar `spec.lifecycle` com valor válido (`experimental`, `production`, `deprecated`).
5. **MUST** declarar `spec.owner` com valor que seja um DNS label válido.
6. **SHOULD** incluir `metadata.annotations["foral.dev/archetype"]` para classificação.
7. **SHOULD** seguir as [Naming Conventions](#5-naming-conventions) para nomes de repositório,
   branches, tags e arquivos.
8. **SHOULD** seguir [Conventional Commits 1.0.0](https://www.conventionalcommits.org/) para
   mensagens de commit.
9. **MAY** estender o schema com campos adicionais, desde que os campos obrigatórios estejam presentes.

---

## 4. Data Model

### 4.1 Catalog Info (Backstage catalog-info.yaml)

O manifesto de cada membro federado segue o formato [Backstage catalog-info.yaml](https://backstage.io/docs/features/software-catalog/descriptor-format/)
(CNCF Incubating), estendido com:

- **`@context`** (obrigatório): URI JSON-LD 1.1 que resolve para o contexto semântico.
- **`foral.dev/*` annotations**: namespace de annotations Foral (formato K8s label).

#### 4.1.1 Exemplo Mínimo

```yaml
"@context": "https://foral-project.github.io/protocol/context/v1/catalog.jsonld"
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-service
  description: "Serviço de exemplo."
  annotations:
    foral.dev/archetype: application
spec:
  type: service
  lifecycle: experimental
  owner: my-team
```

#### 4.1.2 Campos Obrigatórios

| Campo | Tipo | Constraint |
|---|---|---|
| `@context` | string (URI) | MUST resolver para `https://foral-project.github.io/protocol/context/v1/*.jsonld` |
| `apiVersion` | string | `backstage.io/v1alpha1` ou `backstage.io/v1beta1` |
| `kind` | string | Enum Backstage: `Component`, `API`, `Resource`, etc. |
| `metadata.name` | string | DNS label (RFC 1123), max 63 chars |
| `spec.type` | string | Livre (recomendado: `service`, `library`, `website`) |
| `spec.lifecycle` | string | `experimental`, `production`, `deprecated` |
| `spec.owner` | string | DNS label (referência a grupo ou usuário) |

### 4.2 Federation Registry (Backstage Catalog Locations)

O registry lista todos os membros federados de uma governance instance, usando o
formato [Backstage catalog locations](https://backstage.io/docs/features/software-catalog/life-of-an-entity#catalog-locations).

#### 4.2.1 Exemplo

```yaml
"@context": "https://foral-project.github.io/protocol/context/v1/registry.jsonld"
apiVersion: foral.dev/v1
kind: FederationRegistry
metadata:
  name: foral-production
spec:
  protocol:
    type: url
    target: "https://github.com/foral-project/protocol"
    version: "v0.1.0"
  locations:
    - type: url
      target: "https://github.com/foral-project/infra-compute/blob/main/catalog-info.yaml"
      version: "v1.0.0"
```

#### 4.2.2 Campos Obrigatórios

| Campo | Tipo | Constraint |
|---|---|---|
| `@context` | string (URI) | MUST resolver para registry.jsonld |
| `apiVersion` | string | `foral.dev/v1` |
| `kind` | string | `FederationRegistry` |
| `metadata.name` | string | DNS label (RFC 1123) |
| `spec.protocol` | object | Referência ao protocol repo + version tag |
| `spec.locations` | array | Lista de membros (pode ser vazia) |

---

## 5. Naming Conventions

Todas as convenções de naming rastreiam a standards oficiais ou de facto.
Nenhuma regra é inventada.

### 5.1 Repository Names (RFC 1123)

- **Standard:** RFC 1123 DNS Label
- **Pattern:** `[a-z0-9]([a-z0-9-]*[a-z0-9])?`
- **Max length:** 63 caracteres
- **Proibido:** uppercase, underscores, pontos

```
✅ foral-protocol     ✅ infra-compute     ✅ telegram-master
❌ InfraCompute       ❌ infra_compute     ❌ telegram.master
```

### 5.2 File Names (POSIX + per-ecosystem)

| Tipo de arquivo | Formato | Exemplo | Standard |
|---|---|---|---|
| YAML config/manifest | kebab-case `.yaml` | `catalog-info.yaml` | Backstage (CNCF) |
| HCL (OpenTofu) | snake_case `.tf` | `main.tf`, `variables.tf` | OpenTofu/HashiCorp |
| Root docs | UPPERCASE `.md` | `README.md`, `LICENSE` | GitHub/CNCF de facto |
| ADR | `NNNN-kebab.md` | `0001-naming-standards.md` | Nygard (de facto) |
| OPA/Rego | kebab-case `.rego` | `catalog-info.rego` | CNCF/Styra |
| JSON Schema | `nome.schema.yaml` | `catalog-info.schema.yaml` | IETF convention |
| JSON-LD context | kebab-case `.jsonld` | `catalog.jsonld` | W3C convention |

### 5.3 Cloud Resources (RFC 1123 + Industry Convention)

Pattern documentado por Google Cloud, Azure CAF e AWS:

```
{project}-{environment}-{resource}-{qualifier}
```

Segmentos informativos separados por hyphens, lowercase, left-to-right por significância.

```
✅ foral-prod-vm-arm01     ✅ foral-dev-db-primary
```

### 5.4 Branches

| Pattern | Uso | Standard |
|---|---|---|
| `main` | Trunk (protegido) | Trunk-Based Development (Google DORA) |
| `feature/description` | Nova funcionalidade | GitFlow prefixes (de facto) |
| `fix/description` | Correção | GitFlow prefixes |
| `docs/description` | Documentação | GitFlow prefixes |
| `release/vX.Y.Z` | Preparação de release | SemVer 2.0.0 |

Format: `[a-z]+/[a-z0-9-]+`

### 5.5 Tags / Releases

- **Standard:** SemVer 2.0.0
- **Format:** `v{MAJOR}.{MINOR}.{PATCH}` → `v0.1.0`, `v1.0.0`

### 5.6 Commits

- **Standard:** Conventional Commits 1.0.0
- **Format:** `type(scope): description`

```
feat(schemas): add federation-registry schema
fix(ci): correct cross-repo validation token
docs(protocol): update naming specification
```

### 5.7 Variables

| Contexto | Formato | Standard |
|---|---|---|
| CI/CD secrets | SCREAMING_SNAKE_CASE | POSIX (IEEE 1003.1) |
| OpenTofu variables | snake_case | OpenTofu/HashiCorp |
| Environment variables | SCREAMING_SNAKE_CASE | POSIX (IEEE 1003.1) |

### 5.8 Labels / Annotations

| Namespace | Exemplo | Standard |
|---|---|---|
| `backstage.io/*` | `backstage.io/techdocs-ref` | CNCF (Backstage) |
| `foral.dev/*` | `foral.dev/archetype` | K8s Label Syntax |

> O namespace `foral.dev/*` é o único namespace custom. O formato
> `<domain>/<key>` é documentado na K8s Label Spec.

---

## 6. Schema Definitions

Todos os schemas usam **JSON Schema Draft 2020-12** (IETF).

### 6.1 Catalog Info Schema

- **$id:** `https://foral-project.github.io/protocol/schemas/v1/catalog-info.schema.yaml`
- **Valida:** `catalog-info.yaml` de cada membro federado
- **Localização:** [`schemas/v1/catalog-info.schema.yaml`](schemas/v1/catalog-info.schema.yaml)

### 6.2 Federation Registry Schema

- **$id:** `https://foral-project.github.io/protocol/schemas/v1/federation-registry.schema.yaml`
- **Valida:** `federation-registry.yaml` da governance instance
- **Localização:** [`schemas/v1/federation-registry.schema.yaml`](schemas/v1/federation-registry.schema.yaml)

---

## 7. Semantic Context (JSON-LD 1.1)

Cada manifesto YAML do protocolo MUST incluir um campo `@context` que resolve para
um documento JSON-LD 1.1 (W3C Recommendation).

### 7.1 Catalog Context

- **URI:** `https://foral-project.github.io/protocol/context/v1/catalog.jsonld`
- **Mapeia:** termos Backstage + Schema.org para URIs semânticas
- **Localização:** [`context/v1/catalog.jsonld`](context/v1/catalog.jsonld)

### 7.2 Registry Context

- **URI:** `https://foral-project.github.io/protocol/context/v1/registry.jsonld`
- **Mapeia:** termos de registry para URIs semânticas
- **Localização:** [`context/v1/registry.jsonld`](context/v1/registry.jsonld)

### 7.3 Resolução

Os contextos são servidos via GitHub Pages no repositório `foral-project/protocol`.
Qualquer implementação que resolva as URIs `@context` MUST obter documentos JSON-LD
válidos contendo os mapeamentos de termos.

---

## 8. Event Vocabulary (CloudEvents 1.0.3)

Eventos no ecossistema Foral seguem o formato **CloudEvents 1.0.3** (CNCF Graduated).

### 8.1 Type Attribute

Formato: reverse-DNS

| Evento | Type |
|---|---|
| Membro admitido à federação | `com.foral.member.admitted` |
| Membro removido | `com.foral.member.removed` |
| Manifesto validado com sucesso | `com.foral.catalog.validated` |
| Validação falhou | `com.foral.catalog.rejected` |
| Registry atualizado | `com.foral.registry.updated` |

### 8.2 Source Attribute

Formato: URI do repositório de origem

```
//github.com/foral-project/governance
```

### 8.3 Exemplo

```json
{
  "specversion": "1.0",
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "type": "com.foral.member.admitted",
  "source": "//github.com/foral-project/governance",
  "time": "2026-04-20T12:00:00Z",
  "datacontenttype": "application/json",
  "data": {
    "member": "infra-compute",
    "registry": "foral-production"
  }
}
```

---

## 9. Versioning (SemVer 2.0.0)

### 9.1 Protocol Versioning

O protocolo segue **SemVer 2.0.0** (semver.org):

- **MAJOR:** Breaking changes (campos obrigatórios adicionados/removidos, schemas incompatíveis)
- **MINOR:** Funcionalidades retrocompatíveis (novos campos opcionais, novos archetypes)
- **PATCH:** Correções (typos, clarificações, exemplos)

### 9.2 Schema Versioning

Schemas são versionados pelo diretório:

```
schemas/v1/catalog-info.schema.yaml   ← current
schemas/v2/catalog-info.schema.yaml   ← future breaking change
```

### 9.3 Compatibility

Governance instances MUST declarar a versão do protocolo que consomem no
`federation-registry.yaml` (campo `spec.protocol.version`). Um membro é
compatível se seu `catalog-info.yaml` valida contra o schema da versão declarada.

---

## 10. Extension Points

O protocolo é extensível nos seguintes pontos:

### 10.1 Custom Annotations

Membros MAY adicionar annotations com namespaces próprios, seguindo o formato
K8s label syntax (`<domain>/<key>`):

```yaml
metadata:
  annotations:
    foral.dev/archetype: application
    myorg.com/cost-center: "CC-1234"
```

### 10.2 Custom Archetypes

O enum `foral.dev/archetype` é extensível. Valores padrão:
`protocol`, `governance`, `infrastructure`, `application`, `bot`.

Governance instances MAY adicionar archetypes via OPA policies.

### 10.3 Spec Extensions

O campo `spec` aceita propriedades adicionais além dos campos obrigatórios.
Membros MAY declarar campos custom sem violar conformidade.

### 10.4 Event Extensions

Novos event types SHOULD seguir o padrão reverse-DNS com prefixo `com.foral.`.

---

## Appendix A: Standard References

| Standard | Organização | Versão | URL |
|---|---|---|---|
| JSON Schema | IETF | Draft 2020-12 | <https://json-schema.org/draft/2020-12/schema> |
| JSON-LD | W3C | 1.1 Recommendation | <https://www.w3.org/TR/json-ld11/> |
| CloudEvents | CNCF | 1.0.3 | <https://github.com/cloudevents/spec/blob/v1.0.3/cloudevents/spec.md> |
| Backstage | CNCF | Incubating | <https://backstage.io/docs/features/software-catalog/descriptor-format/> |
| SemVer | semver.org | 2.0.0 | <https://semver.org/spec/v2.0.0.html> |
| Conventional Commits | conventionalcommits.org | 1.0.0 | <https://www.conventionalcommits.org/en/v1.0.0/> |
| RFC 1123 (DNS Labels) | IETF | — | <https://www.rfc-editor.org/rfc/rfc1123> |
| RFC 2119 (Key Words) | IETF | — | <https://www.rfc-editor.org/rfc/rfc2119> |
| POSIX Filenames | IEEE | 1003.1 | <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html> |
| OPA/Conftest | CNCF | Graduated | <https://www.openpolicyagent.org/docs/latest/> |
| arc42 | arc42.org | — | <https://arc42.org/overview> |
| ADR (Nygard) | Cognitect | — | <https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions> |
| Apache-2.0 | OSI | — | <https://opensource.org/license/apache-2-0/> |
