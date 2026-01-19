# Implementation Instructions

This is the authoritative instruction file for the **Implementation** phase in this repository.

## Scope
- Applies to all modules and all CI/CD changes.
- Must be kept consistent with workflows under `.github/workflows/` and scripts under `tools/`.

## Required outputs
- Diff with minimal scope
- Shellcheck clean
- Idempotency proof
- No placeholders
This file defines *how the agent works in this repository*, including SDLC-phase playbooks, required outputs, and CI/CD integration patterns for the p6m7g8-dotfiles zsh framework.

## Non-negotiables

### Do
- Prefer deterministic commands; pin tool versions where practical.
- Fail fast in CI: set -euo pipefail, explicit error messages.
- Use repo-local scripts under tools/ and call them from workflows.
- Keep changes minimal and reviewable; avoid drive-by refactors.
- Document decisions in ADR-style notes when tradeoffs exist.

### Don't
- Do not introduce placeholders; use real repo names/paths.
- Do not change public interfaces without migration notes.
- Do not add network calls in tests unless explicitly mocked.
- Do not silence linters without justification and scope.

## Repository invariants (p6df framework)

- Each module is a directory at repo root (e.g., `p6df-gcp/`) with an `init.zsh` entrypoint.
- Module hooks are discovered and invoked by the core recursion engine; implement only hooks you need.
- Common hooks: `deps()`, `init(_module, dir)`, `external::brew()`, `home::symlinks()`, `langs()`, plus prompt/alias/completions/vscodes sub-hooks.
- Prefer p6-provided helpers (`p6_file_*`, `p6_env_export`, `p6_return_void`) to keep behavior consistent across modules.

## Standard deliverables for every change

- A minimal diff that compiles/loads in Zsh without errors.
- A clear commit message and (when applicable) PR description with rationale + test evidence.
- Updated docs/README if behavior or usage changes.
- CI green: lint + tests + formatting + security checks (where configured).
- No new unpinned dependencies without justification.

## SDLC phase playbooks

### Phase: Specification (`spec`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- A crisp problem statement and acceptance criteria.
- Enumerated constraints: OS targets, shells, CI runners, Homebrew vs other installers.
- A “done means” checklist aligned to tests/linters.
- An explicit list of touched modules/files.

**Checklists**
- [ ] Capture user intent in one paragraph.
- [ ] List explicit inputs (files, env vars, CLI args) and outputs.
- [ ] Enumerate invariants: naming, module hooks, p6 helper usage.
- [ ] Define acceptance tests in command form (copy/paste runnable).
- [ ] Identify which workflows are impacted (lint/test/release).

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Design (`design`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Proposed interface (function names, env vars, hook placement).
- Dataflow: inputs/outputs, error handling, side effects.
- Backward compatibility strategy and migration notes.
- Security considerations (secrets, token handling, least privilege).

**Checklists**
- [ ] Choose the correct hook (init vs home::symlinks vs external::brew vs langs).
- [ ] Decide whether changes belong in p6df-core (shared) or module-local.
- [ ] Plan error handling: return codes, messages, and optional verbosity.
- [ ] Plan idempotency: repeated runs must not break.
- [ ] Plan CI: ensure changes are runnable on GitHub-hosted runners.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Review (`review`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Self-review checklist executed (style, safety, portability).
- Risky changes called out with mitigations.
- Test plan and evidence links or command output snippets.
- Doc impact summary.

**Checklists**
- [ ] Run shellcheck on touched scripts; fix warnings or justify ignores.
- [ ] Verify quoting and whitespace safety (`"$var"`, arrays).
- [ ] Confirm no secrets added; ensure token usage via env/secret stores.
- [ ] Confirm no surprising side effects in init hooks.
- [ ] Confirm README updated where behavior changed.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Pull Request (`pr`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- PR title and description with context, scope, and verification steps.
- Labels / reviewers suggestions; identify owners per module.
- Changelog note if user-visible behavior changes.
- Rollback plan if CI or production install fails.

**Checklists**
- [ ] PR description includes: what/why/how/tested.
- [ ] Attach command output snippets for verification.
- [ ] Call out breaking changes and migration steps.
- [ ] Ensure CI jobs cover the change type.
- [ ] Ensure reviewers include module/domain owners.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Implementation (`code`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Implementation diff with tight scope.
- Consistent naming and hook usage; no duplication across modules.
- Idempotent functions; safe quoting; set -euo pipefail where applicable.
- Shellcheck compliance and minimal suppressions with rationale.

**Checklists**
- [ ] Prefer pure functions for computation; isolate side effects.
- [ ] Use p6 helper functions for file ops and env exports.
- [ ] Keep functions small; one responsibility each.
- [ ] Avoid duplicating logic across modules; factor to core if reusable.
- [ ] Add comments only where behavior is non-obvious.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: QA & Fix (`qa-fix`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Repro steps (local + CI).
- Regression tests or at least deterministic command checks.
- Failure-mode validation (missing brew, missing file, non-macOS).
- Fix-forward notes and postmortem bullets if a regression occurred.

**Checklists**
- [ ] Create a minimal repro script or steps.
- [ ] Test clean shell session + existing configured session.
- [ ] Test failure cases (missing binaries, missing files, permissions).
- [ ] Validate module recursion order doesn’t break dependencies.
- [ ] Confirm CI mirrors local checks.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Build (`build`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Build definition updates (workflows, scripts, caching).
- Artifact outputs clearly named and versioned.
- CI time budget accounted for; parallelization and caching used.
- Reproducibility: lockfiles/pins documented.

**Checklists**
- [ ] Cache package managers appropriately (brew, npm/pnpm, go, python).
- [ ] Pin tool versions and document upgrades.
- [ ] Use matrix builds sparingly but effectively.
- [ ] Avoid brittle parsing; prefer stable CLI formats.
- [ ] Make logs actionable: group steps, echo commands, clear failures.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Deploy (`deploy`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Deployment steps for dotfiles: install order, symlinks, brew, langs hooks.
- Environment variable requirements documented.
- Safety rails: dry-run options, backups, rollback.
- Post-deploy verification commands.

**Checklists**
- [ ] Document install order and prerequisites.
- [ ] Ensure symlink operations are safe and idempotent.
- [ ] Ensure brew installs are guarded and optional where appropriate.
- [ ] Add post-deploy smoke tests.
- [ ] Provide rollback instructions.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

### Phase: Release (`release`)

**Inputs**
- The user request / issue statement (explicit requirements).
- Current repo constraints (existing functions, naming, hooks, CI).
- Risks: portability, shell compatibility, CI runtime, security.

**Outputs (must produce)**
- Release checklist: version bump, tag, notes.
- Compatibility matrix updates (macOS versions, shells).
- Migration notes consolidated.
- Final smoke test plan.

**Checklists**
- [ ] Update CHANGELOG/notes.
- [ ] Tag and verify artifact integrity.
- [ ] Smoke test on a fresh user account or clean VM.
- [ ] Verify docs site / README renders and links.
- [ ] Announce breaking changes clearly.

**CI/CD mapping**
- Jobs: lint (shellcheck/markdownlint/cspell), unit (if any), integration (install/symlink dry-run), security (secret scan), release (tag/notes).
- Evidence: attach logs or paste commands and outputs in PR.

## Commands (copy/paste)

### Local quality gate
```sh
set -euo pipefail
# shell scripts
find . -name "*.zsh" -o -name "*.sh" | while read -r f; do shellcheck "$f"; done
# docs (if present)
if command -v markdownlint >/dev/null; then markdownlint .; fi
if command -v cspell >/dev/null; then cspell lint .; fi
```

## GitHub Actions integration expectations

- Workflows should call repo scripts, not inline large logic.
- Use `actions/checkout@v4` and minimal permissions by default.
- Cache keys must include OS + tool version + lockfile hash.
- Prefer `bash` steps with `set -euo pipefail` for determinism.
- If using tokens, ensure scopes are minimal and stored in GitHub Secrets.

## Module-specific notes

The following sections are maintained as living documentation. When you touch a module, update its section with decisions, invariants, and verification commands.

### Module: `p61password`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p61password"
# shellcheck disable=SC2016
```

### Module: `p6aws`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6aws"
# shellcheck disable=SC2016
```

### Module: `p6awscdk`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6awscdk"
# shellcheck disable=SC2016
```

### Module: `p6common`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6common"
# shellcheck disable=SC2016
```

### Module: `p6df`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df"
# shellcheck disable=SC2016
```

### Module: `p6df-1password`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-1password"
# shellcheck disable=SC2016
```

### Module: `p6df-R`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-R"
# shellcheck disable=SC2016
```

### Module: `p6df-akuity`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-akuity"
# shellcheck disable=SC2016
```

### Module: `p6df-alfred`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-alfred"
# shellcheck disable=SC2016
```

### Module: `p6df-argocd`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-argocd"
# shellcheck disable=SC2016
```

### Module: `p6df-arkestro`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-arkestro"
# shellcheck disable=SC2016
```

### Module: `p6df-aws`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-aws"
# shellcheck disable=SC2016
```

### Module: `p6df-awscdk`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-awscdk"
# shellcheck disable=SC2016
```

### Module: `p6df-awssam`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-awssam"
# shellcheck disable=SC2016
```

### Module: `p6df-azure`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-azure"
# shellcheck disable=SC2016
```

### Module: `p6df-bash`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-bash"
# shellcheck disable=SC2016
```

### Module: `p6df-c`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-c"
# shellcheck disable=SC2016
```

### Module: `p6df-cdk8s`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-cdk8s"
# shellcheck disable=SC2016
```

### Module: `p6df-cdktf`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-cdktf"
# shellcheck disable=SC2016
```

### Module: `p6df-claude-code`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-claude-code"
# shellcheck disable=SC2016
```

### Module: `p6df-cloudflare`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-cloudflare"
# shellcheck disable=SC2016
```

### Module: `p6df-cloudsmith`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-cloudsmith"
# shellcheck disable=SC2016
```

### Module: `p6df-core`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-core"
# shellcheck disable=SC2016
```

### Module: `p6df-cucumber`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-cucumber"
# shellcheck disable=SC2016
```

### Module: `p6df-darwin`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-darwin"
# shellcheck disable=SC2016
```

### Module: `p6df-databricks`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-databricks"
# shellcheck disable=SC2016
```

### Module: `p6df-datadog`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-datadog"
# shellcheck disable=SC2016
```

### Module: `p6df-dbt`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-dbt"
# shellcheck disable=SC2016
```

### Module: `p6df-docker`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-docker"
# shellcheck disable=SC2016
```

### Module: `p6df-eslint`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-eslint"
# shellcheck disable=SC2016
```

### Module: `p6df-gcp`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-gcp"
# shellcheck disable=SC2016
```

### Module: `p6df-gemini`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-gemini"
# shellcheck disable=SC2016
```

### Module: `p6df-go`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-go"
# shellcheck disable=SC2016
```

### Module: `p6df-graphql`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-graphql"
# shellcheck disable=SC2016
```

### Module: `p6df-helm`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-helm"
# shellcheck disable=SC2016
```

### Module: `p6df-heroku`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-heroku"
# shellcheck disable=SC2016
```

### Module: `p6df-homebrew`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-homebrew"
# shellcheck disable=SC2016
```

### Module: `p6df-huggingface`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-huggingface"
# shellcheck disable=SC2016
```

### Module: `p6df-irc`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-irc"
# shellcheck disable=SC2016
```

### Module: `p6df-java`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-java"
# shellcheck disable=SC2016
```

### Module: `p6df-jenkins`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-jenkins"
# shellcheck disable=SC2016
```

### Module: `p6df-jira`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-jira"
# shellcheck disable=SC2016
```

### Module: `p6df-js`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-js"
# shellcheck disable=SC2016
```

### Module: `p6df-julia`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-julia"
# shellcheck disable=SC2016
```

### Module: `p6df-jupyter`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-jupyter"
# shellcheck disable=SC2016
```

### Module: `p6df-kafka`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-kafka"
# shellcheck disable=SC2016
```

### Module: `p6df-kaggle`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-kaggle"
# shellcheck disable=SC2016
```

### Module: `p6df-kubernetes`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-kubernetes"
# shellcheck disable=SC2016
```

### Module: `p6df-launchdarkly`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-launchdarkly"
# shellcheck disable=SC2016
```

### Module: `p6df-linkedin`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-linkedin"
# shellcheck disable=SC2016
```

### Module: `p6df-lua`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-lua"
# shellcheck disable=SC2016
```

### Module: `p6df-macosx`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-macosx"
# shellcheck disable=SC2016
```

### Module: `p6df-mysql`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-mysql"
# shellcheck disable=SC2016
```

### Module: `p6df-newrelic`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-newrelic"
# shellcheck disable=SC2016
```

### Module: `p6df-nmap`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-nmap"
# shellcheck disable=SC2016
```

### Module: `p6df-oci`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-oci"
# shellcheck disable=SC2016
```

### Module: `p6df-okta`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-okta"
# shellcheck disable=SC2016
```

### Module: `p6df-openai`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-openai"
# shellcheck disable=SC2016
```

### Module: `p6df-oracle`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-oracle"
# shellcheck disable=SC2016
```

### Module: `p6df-pagerduty`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-pagerduty"
# shellcheck disable=SC2016
```

### Module: `p6df-perl`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-perl"
# shellcheck disable=SC2016
```

### Module: `p6df-pgsql`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-pgsql"
# shellcheck disable=SC2016
```

### Module: `p6df-playwright`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-playwright"
# shellcheck disable=SC2016
```

### Module: `p6df-profile`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-profile"
# shellcheck disable=SC2016
```

### Module: `p6df-projen`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-projen"
# shellcheck disable=SC2016
```

### Module: `p6df-proxy`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-proxy"
# shellcheck disable=SC2016
```

### Module: `p6df-python`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-python"
# shellcheck disable=SC2016
```

### Module: `p6df-rails`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-rails"
# shellcheck disable=SC2016
```

### Module: `p6df-redis`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-redis"
# shellcheck disable=SC2016
```

### Module: `p6df-ruby`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-ruby"
# shellcheck disable=SC2016
```

### Module: `p6df-rust`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-rust"
# shellcheck disable=SC2016
```

### Module: `p6df-scala`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-scala"
# shellcheck disable=SC2016
```

### Module: `p6df-shell`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-shell"
# shellcheck disable=SC2016
```

### Module: `p6df-slack`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-slack"
# shellcheck disable=SC2016
```

### Module: `p6df-snowflake`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-snowflake"
# shellcheck disable=SC2016
```

### Module: `p6df-solidity`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-solidity"
# shellcheck disable=SC2016
```

### Module: `p6df-sqlite`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-sqlite"
# shellcheck disable=SC2016
```

### Module: `p6df-sqlserver`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-sqlserver"
# shellcheck disable=SC2016
```

### Module: `p6df-sudo`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-sudo"
# shellcheck disable=SC2016
```

### Module: `p6df-teleport`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-teleport"
# shellcheck disable=SC2016
```

### Module: `p6df-terraform`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-terraform"
# shellcheck disable=SC2016
```

### Module: `p6df-tmux`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-tmux"
# shellcheck disable=SC2016
```

### Module: `p6df-vim`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-vim"
# shellcheck disable=SC2016
```

### Module: `p6df-vscode`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-vscode"
# shellcheck disable=SC2016
```

### Module: `p6df-zsh`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6df-zsh"
# shellcheck disable=SC2016
```

### Module: `p6helm`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6helm"
# shellcheck disable=SC2016
```

### Module: `p6jenkins`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6jenkins"
# shellcheck disable=SC2016
```

### Module: `p6kubernetes`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6kubernetes"
# shellcheck disable=SC2016
```

### Module: `p6macosx`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6macosx"
# shellcheck disable=SC2016
```

### Module: `p6perl`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6perl"
# shellcheck disable=SC2016
```

### Module: `p6pgsql`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6pgsql"
# shellcheck disable=SC2016
```

### Module: `p6python`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6python"
# shellcheck disable=SC2016
```

### Module: `p6shell`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6shell"
# shellcheck disable=SC2016
```

### Module: `p6sqlite`

**Purpose**: (update when modifying this module)
- Owns tooling/configuration for a specific domain (CLI, language manager, service, etc.).

**Hooks likely used**
- `deps()` if it needs other modules loaded first.
- `external::brew()` for Homebrew installs/casks.
- `home::symlinks()` for dotfile/link placement under `$HOME`.
- `init()` for PATH/env/aliases/completions/prompt integration.

**Verification commands**
```sh
# Load module (pattern; adapt to your loader)
echo "verify p6sqlite"
# shellcheck disable=SC2016
```

## Appendix: detailed checklists (expanded)

### Shell Safety
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #1)
- [ ] Prefer arrays over string concatenation for argv building. (check #2)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #3)
- [ ] Guard external commands with `command -v` when optional. (check #4)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #5)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #6)
- [ ] Prefer arrays over string concatenation for argv building. (check #7)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #8)
- [ ] Guard external commands with `command -v` when optional. (check #9)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #10)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #11)
- [ ] Prefer arrays over string concatenation for argv building. (check #12)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #13)
- [ ] Guard external commands with `command -v` when optional. (check #14)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #15)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #16)
- [ ] Prefer arrays over string concatenation for argv building. (check #17)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #18)
- [ ] Guard external commands with `command -v` when optional. (check #19)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #20)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #21)
- [ ] Prefer arrays over string concatenation for argv building. (check #22)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #23)
- [ ] Guard external commands with `command -v` when optional. (check #24)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #25)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #26)
- [ ] Prefer arrays over string concatenation for argv building. (check #27)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #28)
- [ ] Guard external commands with `command -v` when optional. (check #29)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #30)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #31)
- [ ] Prefer arrays over string concatenation for argv building. (check #32)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #33)
- [ ] Guard external commands with `command -v` when optional. (check #34)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #35)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #36)
- [ ] Prefer arrays over string concatenation for argv building. (check #37)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #38)
- [ ] Guard external commands with `command -v` when optional. (check #39)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #40)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #41)
- [ ] Prefer arrays over string concatenation for argv building. (check #42)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #43)
- [ ] Guard external commands with `command -v` when optional. (check #44)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #45)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #46)
- [ ] Prefer arrays over string concatenation for argv building. (check #47)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #48)
- [ ] Guard external commands with `command -v` when optional. (check #49)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #50)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #51)
- [ ] Prefer arrays over string concatenation for argv building. (check #52)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #53)
- [ ] Guard external commands with `command -v` when optional. (check #54)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #55)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #56)
- [ ] Prefer arrays over string concatenation for argv building. (check #57)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #58)
- [ ] Guard external commands with `command -v` when optional. (check #59)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #60)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #61)
- [ ] Prefer arrays over string concatenation for argv building. (check #62)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #63)
- [ ] Guard external commands with `command -v` when optional. (check #64)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #65)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #66)
- [ ] Prefer arrays over string concatenation for argv building. (check #67)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #68)
- [ ] Guard external commands with `command -v` when optional. (check #69)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #70)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #71)
- [ ] Prefer arrays over string concatenation for argv building. (check #72)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #73)
- [ ] Guard external commands with `command -v` when optional. (check #74)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #75)
- [ ] Quote all variable expansions unless intentional word-splitting is required. (check #76)
- [ ] Prefer arrays over string concatenation for argv building. (check #77)
- [ ] Avoid `eval` unless unavoidable; document why if used. (check #78)
- [ ] Guard external commands with `command -v` when optional. (check #79)
- [ ] Return explicit non-zero on failure; avoid silent failures. (check #80)

### Portability
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #1)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #2)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #3)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #4)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #5)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #6)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #7)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #8)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #9)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #10)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #11)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #12)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #13)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #14)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #15)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #16)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #17)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #18)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #19)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #20)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #21)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #22)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #23)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #24)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #25)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #26)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #27)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #28)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #29)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #30)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #31)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #32)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #33)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #34)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #35)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #36)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #37)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #38)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #39)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #40)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #41)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #42)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #43)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #44)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #45)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #46)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #47)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #48)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #49)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #50)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #51)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #52)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #53)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #54)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #55)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #56)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #57)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #58)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #59)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #60)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #61)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #62)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #63)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #64)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #65)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #66)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #67)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #68)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #69)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #70)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #71)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #72)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #73)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #74)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #75)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #76)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #77)
- [ ] Avoid relying on locale-dependent output; set LC_ALL=C if parsing. (check #78)
- [ ] Assume macOS (primary) but avoid GNU-only flags when possible. (check #79)
- [ ] Prefer POSIX utilities; if gnu required, detect and document. (check #80)

### GitHub Actions
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #1)
- [ ] Pin action versions to major or SHA where appropriate. (check #2)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #3)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #4)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #5)
- [ ] Pin action versions to major or SHA where appropriate. (check #6)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #7)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #8)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #9)
- [ ] Pin action versions to major or SHA where appropriate. (check #10)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #11)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #12)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #13)
- [ ] Pin action versions to major or SHA where appropriate. (check #14)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #15)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #16)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #17)
- [ ] Pin action versions to major or SHA where appropriate. (check #18)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #19)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #20)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #21)
- [ ] Pin action versions to major or SHA where appropriate. (check #22)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #23)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #24)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #25)
- [ ] Pin action versions to major or SHA where appropriate. (check #26)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #27)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #28)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #29)
- [ ] Pin action versions to major or SHA where appropriate. (check #30)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #31)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #32)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #33)
- [ ] Pin action versions to major or SHA where appropriate. (check #34)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #35)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #36)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #37)
- [ ] Pin action versions to major or SHA where appropriate. (check #38)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #39)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #40)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #41)
- [ ] Pin action versions to major or SHA where appropriate. (check #42)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #43)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #44)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #45)
- [ ] Pin action versions to major or SHA where appropriate. (check #46)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #47)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #48)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #49)
- [ ] Pin action versions to major or SHA where appropriate. (check #50)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #51)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #52)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #53)
- [ ] Pin action versions to major or SHA where appropriate. (check #54)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #55)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #56)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #57)
- [ ] Pin action versions to major or SHA where appropriate. (check #58)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #59)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #60)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #61)
- [ ] Pin action versions to major or SHA where appropriate. (check #62)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #63)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #64)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #65)
- [ ] Pin action versions to major or SHA where appropriate. (check #66)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #67)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #68)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #69)
- [ ] Pin action versions to major or SHA where appropriate. (check #70)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #71)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #72)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #73)
- [ ] Pin action versions to major or SHA where appropriate. (check #74)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #75)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #76)
- [ ] Use `permissions:` minimal; elevate only per job needs. (check #77)
- [ ] Pin action versions to major or SHA where appropriate. (check #78)
- [ ] Use concurrency groups for release pipelines to avoid races. (check #79)
- [ ] Use `shell: bash` explicitly and set `-euo pipefail`. (check #80)

### Security
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #1)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #2)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #3)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #4)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #5)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #6)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #7)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #8)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #9)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #10)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #11)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #12)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #13)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #14)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #15)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #16)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #17)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #18)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #19)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #20)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #21)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #22)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #23)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #24)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #25)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #26)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #27)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #28)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #29)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #30)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #31)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #32)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #33)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #34)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #35)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #36)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #37)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #38)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #39)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #40)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #41)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #42)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #43)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #44)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #45)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #46)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #47)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #48)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #49)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #50)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #51)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #52)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #53)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #54)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #55)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #56)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #57)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #58)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #59)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #60)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #61)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #62)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #63)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #64)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #65)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #66)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #67)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #68)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #69)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #70)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #71)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #72)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #73)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #74)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #75)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #76)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #77)
- [ ] Prefer OIDC and short-lived creds over long-lived keys. (check #78)
- [ ] Never print secrets; mask tokens; avoid `set -x` in secret steps. (check #79)
- [ ] Validate downloaded artifacts with checksums/signatures when feasible. (check #80)

### Docs
- [ ] Update README usage when adding aliases or env vars. (check #1)
- [ ] Keep examples runnable and minimal. (check #2)
- [ ] Document expected file locations under `$HOME`. (check #3)
- [ ] Update README usage when adding aliases or env vars. (check #4)
- [ ] Keep examples runnable and minimal. (check #5)
- [ ] Document expected file locations under `$HOME`. (check #6)
- [ ] Update README usage when adding aliases or env vars. (check #7)
- [ ] Keep examples runnable and minimal. (check #8)
- [ ] Document expected file locations under `$HOME`. (check #9)
- [ ] Update README usage when adding aliases or env vars. (check #10)
- [ ] Keep examples runnable and minimal. (check #11)
- [ ] Document expected file locations under `$HOME`. (check #12)
- [ ] Update README usage when adding aliases or env vars. (check #13)
- [ ] Keep examples runnable and minimal. (check #14)
- [ ] Document expected file locations under `$HOME`. (check #15)
- [ ] Update README usage when adding aliases or env vars. (check #16)
- [ ] Keep examples runnable and minimal. (check #17)
- [ ] Document expected file locations under `$HOME`. (check #18)
- [ ] Update README usage when adding aliases or env vars. (check #19)
- [ ] Keep examples runnable and minimal. (check #20)
- [ ] Document expected file locations under `$HOME`. (check #21)
- [ ] Update README usage when adding aliases or env vars. (check #22)
- [ ] Keep examples runnable and minimal. (check #23)
- [ ] Document expected file locations under `$HOME`. (check #24)
- [ ] Update README usage when adding aliases or env vars. (check #25)
- [ ] Keep examples runnable and minimal. (check #26)
- [ ] Document expected file locations under `$HOME`. (check #27)
- [ ] Update README usage when adding aliases or env vars. (check #28)
- [ ] Keep examples runnable and minimal. (check #29)
- [ ] Document expected file locations under `$HOME`. (check #30)
- [ ] Update README usage when adding aliases or env vars. (check #31)
- [ ] Keep examples runnable and minimal. (check #32)
- [ ] Document expected file locations under `$HOME`. (check #33)
- [ ] Update README usage when adding aliases or env vars. (check #34)
- [ ] Keep examples runnable and minimal. (check #35)
- [ ] Document expected file locations under `$HOME`. (check #36)
- [ ] Update README usage when adding aliases or env vars. (check #37)
- [ ] Keep examples runnable and minimal. (check #38)
- [ ] Document expected file locations under `$HOME`. (check #39)
- [ ] Update README usage when adding aliases or env vars. (check #40)
- [ ] Keep examples runnable and minimal. (check #41)
- [ ] Document expected file locations under `$HOME`. (check #42)
- [ ] Update README usage when adding aliases or env vars. (check #43)
- [ ] Keep examples runnable and minimal. (check #44)
- [ ] Document expected file locations under `$HOME`. (check #45)
- [ ] Update README usage when adding aliases or env vars. (check #46)
- [ ] Keep examples runnable and minimal. (check #47)
- [ ] Document expected file locations under `$HOME`. (check #48)
- [ ] Update README usage when adding aliases or env vars. (check #49)
- [ ] Keep examples runnable and minimal. (check #50)
- [ ] Document expected file locations under `$HOME`. (check #51)
- [ ] Update README usage when adding aliases or env vars. (check #52)
- [ ] Keep examples runnable and minimal. (check #53)
- [ ] Document expected file locations under `$HOME`. (check #54)
- [ ] Update README usage when adding aliases or env vars. (check #55)
- [ ] Keep examples runnable and minimal. (check #56)
- [ ] Document expected file locations under `$HOME`. (check #57)
- [ ] Update README usage when adding aliases or env vars. (check #58)
- [ ] Keep examples runnable and minimal. (check #59)
- [ ] Document expected file locations under `$HOME`. (check #60)
- [ ] Update README usage when adding aliases or env vars. (check #61)
- [ ] Keep examples runnable and minimal. (check #62)
- [ ] Document expected file locations under `$HOME`. (check #63)
- [ ] Update README usage when adding aliases or env vars. (check #64)
- [ ] Keep examples runnable and minimal. (check #65)
- [ ] Document expected file locations under `$HOME`. (check #66)
- [ ] Update README usage when adding aliases or env vars. (check #67)
- [ ] Keep examples runnable and minimal. (check #68)
- [ ] Document expected file locations under `$HOME`. (check #69)
- [ ] Update README usage when adding aliases or env vars. (check #70)
- [ ] Keep examples runnable and minimal. (check #71)
- [ ] Document expected file locations under `$HOME`. (check #72)
- [ ] Update README usage when adding aliases or env vars. (check #73)
- [ ] Keep examples runnable and minimal. (check #74)
- [ ] Document expected file locations under `$HOME`. (check #75)
- [ ] Update README usage when adding aliases or env vars. (check #76)
- [ ] Keep examples runnable and minimal. (check #77)
- [ ] Document expected file locations under `$HOME`. (check #78)
- [ ] Update README usage when adding aliases or env vars. (check #79)
- [ ] Keep examples runnable and minimal. (check #80)

## Appendix: troubleshooting matrix

### Module not loading
- Confirm module directory exists and is in module search path.
- Confirm `init.zsh` syntax: run `zsh -n init.zsh` if available.
- Confirm required deps are listed in `ModuleDeps`.
- Confirm hook names match recursion call sites.
- Diagnostic #1: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #2: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #3: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #4: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #5: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #6: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #7: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #8: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #9: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #10: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #11: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #12: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #13: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #14: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #15: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #16: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #17: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #18: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #19: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #20: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #21: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #22: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #23: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #24: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #25: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #26: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #27: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #28: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #29: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #30: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #31: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #32: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #33: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #34: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #35: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #36: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #37: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #38: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #39: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #40: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #41: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #42: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #43: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #44: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #45: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #46: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #47: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #48: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #49: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #50: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #51: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #52: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #53: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #54: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #55: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #56: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #57: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #58: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #59: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #60: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #61: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #62: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #63: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #64: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #65: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #66: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #67: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #68: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #69: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #70: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #71: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #72: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #73: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #74: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #75: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #76: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #77: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #78: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #79: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #80: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #81: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #82: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #83: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #84: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #85: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #86: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #87: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #88: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #89: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #90: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #91: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #92: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #93: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #94: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #95: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #96: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #97: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #98: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #99: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #100: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #101: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #102: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #103: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #104: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #105: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #106: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #107: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #108: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #109: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #110: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #111: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #112: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #113: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #114: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #115: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #116: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #117: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #118: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #119: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #120: If symptom "Module not loading" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.

### Symlinks not created
- Confirm `home::symlinks()` is implemented and called by core symlink pass.
- Confirm `P6_DFZ_SRC_DIR` points to correct source directory.
- Confirm target paths under `$HOME` exist or are created.
- Confirm `p6_file_symlink` is called with correct args.
- Diagnostic #1: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #2: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #3: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #4: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #5: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #6: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #7: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #8: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #9: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #10: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #11: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #12: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #13: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #14: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #15: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #16: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #17: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #18: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #19: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #20: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #21: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #22: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #23: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #24: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #25: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #26: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #27: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #28: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #29: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #30: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #31: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #32: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #33: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #34: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #35: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #36: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #37: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #38: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #39: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #40: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #41: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #42: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #43: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #44: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #45: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #46: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #47: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #48: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #49: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #50: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #51: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #52: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #53: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #54: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #55: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #56: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #57: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #58: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #59: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #60: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #61: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #62: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #63: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #64: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #65: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #66: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #67: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #68: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #69: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #70: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #71: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #72: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #73: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #74: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #75: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #76: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #77: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #78: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #79: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #80: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #81: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #82: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #83: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #84: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #85: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #86: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #87: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #88: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #89: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #90: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #91: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #92: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #93: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #94: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #95: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #96: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #97: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #98: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #99: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #100: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #101: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #102: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #103: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #104: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #105: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #106: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #107: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #108: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #109: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #110: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #111: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #112: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #113: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #114: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #115: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #116: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #117: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #118: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #119: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #120: If symptom "Symlinks not created" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.

### CI failing
- Inspect job logs; identify first failing step.
- Reproduce locally with same tool versions if possible.
- Check for missing caches or missing dependency installs.
- Ensure workflows reference scripts under tools/ rather than inline logic.
- Diagnostic #1: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #2: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #3: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #4: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #5: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #6: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #7: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #8: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #9: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #10: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #11: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #12: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #13: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #14: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #15: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #16: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #17: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #18: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #19: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #20: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #21: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #22: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #23: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #24: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #25: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #26: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #27: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #28: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #29: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #30: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #31: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #32: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #33: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #34: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #35: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #36: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #37: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #38: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #39: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #40: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #41: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #42: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #43: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #44: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #45: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #46: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #47: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #48: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #49: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #50: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #51: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #52: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #53: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #54: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #55: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #56: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #57: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #58: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #59: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #60: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #61: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #62: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #63: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #64: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #65: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #66: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #67: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #68: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #69: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #70: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #71: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #72: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #73: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #74: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #75: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #76: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #77: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #78: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #79: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #80: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #81: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #82: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #83: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #84: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #85: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #86: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #87: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #88: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #89: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #90: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #91: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #92: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #93: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #94: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #95: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #96: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #97: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #98: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #99: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #100: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #101: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #102: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #103: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #104: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #105: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #106: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #107: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #108: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #109: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #110: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #111: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #112: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #113: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #114: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #115: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #116: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #117: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #118: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #119: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.
- Diagnostic #120: If symptom "CI failing" persists, capture logs, environment (`env | sort`), and minimal repro commands; attach to PR.

