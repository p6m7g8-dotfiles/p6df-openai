# P6's POSIX.2: p6df-openai

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-openai

##### p6df-openai/init.zsh

- `p6df::modules::openai::aliases::init()`
- `p6df::modules::openai::deps()`
- `p6df::modules::openai::external::brews()`
- `p6df::modules::openai::home::symlink()`
- `p6df::modules::openai::profile::off()`
- `p6df::modules::openai::profile::on(profile, code_env)`
  - Args:
    - profile - 
    - code_env - 
- `p6df::modules::openai::vscodes()`
- `str str = p6df::modules::openai::prompt::mod()`

## Hierarchy

```text
.
├── init.zsh
├── README.md
└── share
    └── codex
        ├── auth.json
        ├── config.toml
        ├── history.jsonl
        ├── log
        │   └── codex-tui.log
        ├── models_cache.json
        ├── rules
        │   └── default.rules
        ├── sessions
        │   └── 2026
        │       ├── 01
        │       │   ├── 28
        │       │   │   ├── rollout-2026-01-28T18-08-30-019c06dd-940b-78e1-8928-a6b5c0537970.jsonl
        │       │   │   ├── rollout-2026-01-28T18-09-47-019c06de-bed1-7113-b9dc-9bd06ed35fb4.jsonl
        │       │   │   └── rollout-2026-01-28T18-10-54-019c06df-c745-7d70-a0ff-4ffa40acf9a1.jsonl
        │       │   ├── 29
        │       │   │   └── rollout-2026-01-29T10-57-27-019c0a79-4d6e-7583-b202-517cf58bf7fe.jsonl
        │       │   └── 31
        │       │       ├── rollout-2026-01-31T10-41-42-019c14b7-9a1d-7133-9a10-23e0629c3e74.jsonl
        │       │       ├── rollout-2026-01-31T10-44-36-019c14ba-41ab-7d41-b202-beb5600ef8e5.jsonl
        │       │       ├── rollout-2026-01-31T13-08-16-019c153d-c91b-7041-be7f-09ff89c4161d.jsonl
        │       │       ├── rollout-2026-01-31T19-55-29-019c16b2-99fb-7c42-a31f-1793f8b9e14b.jsonl
        │       │       ├── rollout-2026-01-31T20-13-51-019c16c3-6a83-70f3-a94b-5909842d659b.jsonl
        │       │       ├── rollout-2026-01-31T20-14-44-019c16c4-37c6-7411-9c3c-c1cfa6bf6b1a.jsonl
        │       │       ├── rollout-2026-01-31T21-14-12-019c16fa-aa32-7733-b1f6-93a3e8eedf6d.jsonl
        │       │       └── rollout-2026-01-31T21-14-36-019c16fb-0a7a-7bc3-bb61-7eaa8b7697ea.jsonl
        │       └── 02
        │           ├── 01
        │           │   ├── rollout-2026-02-01T08-37-14-019c196b-ffa2-7403-8682-29d39a974857.jsonl
        │           │   ├── rollout-2026-02-01T08-38-28-019c196d-2315-7b70-a3d4-e8e1739da97b.jsonl
        │           │   ├── rollout-2026-02-01T08-39-13-019c196d-d371-7d01-b73b-77532f715e5f.jsonl
        │           │   ├── rollout-2026-02-01T09-21-28-019c1994-7fd2-7570-8e3a-a44ae7f41ffd.jsonl
        │           │   ├── rollout-2026-02-01T09-23-51-019c1996-ad45-7762-b007-cc517767f163.jsonl
        │           │   ├── rollout-2026-02-01T09-28-30-019c199a-efb4-7c40-b4b0-ebb5584a2ee4.jsonl
        │           │   ├── rollout-2026-02-01T09-33-08-019c199f-2da6-7110-a5e5-88ff4b6ebb13.jsonl
        │           │   ├── rollout-2026-02-01T09-36-21-019c19a2-20f9-7473-9bff-a8ce655a2e57.jsonl
        │           │   ├── rollout-2026-02-01T09-49-42-019c19ae-5a82-7a53-846c-4dbf50c5fb47.jsonl
        │           │   ├── rollout-2026-02-01T09-58-39-019c19b6-8935-7a52-b51c-e0472261fbec.jsonl
        │           │   ├── rollout-2026-02-01T10-08-00-019c19bf-1933-7291-a135-dcce522c25bd.jsonl
        │           │   ├── rollout-2026-02-01T10-16-02-019c19c6-752b-7df0-a21d-f872aa35f4c2.jsonl
        │           │   ├── rollout-2026-02-01T10-42-06-019c19de-52fa-7430-a120-899fed0a1579.jsonl
        │           │   ├── rollout-2026-02-01T10-43-26-019c19df-8b88-7971-b29b-0597b40d2462.jsonl
        │           │   ├── rollout-2026-02-01T10-52-39-019c19e7-f9f8-7f50-940b-cb07cf4e27be.jsonl
        │           │   ├── rollout-2026-02-01T12-32-31-019c1a43-68ed-7881-9ea0-6a4ce1c440c2.jsonl
        │           │   ├── rollout-2026-02-01T12-34-12-019c1a44-f348-7111-84fe-487a573be6b2.jsonl
        │           │   ├── rollout-2026-02-01T12-40-59-019c1a4b-2b1b-7513-ad78-15b6b6e34cf7.jsonl
        │           │   ├── rollout-2026-02-01T12-42-32-019c1a4c-945f-7800-a6ea-17a5bcabf2f8.jsonl
        │           │   ├── rollout-2026-02-01T19-02-57-019c1ba8-dc8f-79d3-8842-00749824bb0d.jsonl
        │           │   ├── rollout-2026-02-01T19-12-20-019c1bb1-7519-7b00-8af3-33ca72201e8b.jsonl
        │           │   ├── rollout-2026-02-01T20-25-38-019c1bf4-91a7-77d2-850b-c6d18fb9f3f8.jsonl
        │           │   └── rollout-2026-02-01T21-47-32-019c1c3f-8b5b-7851-aa05-03837f247b4e.jsonl
        │           ├── 02
        │           │   ├── rollout-2026-02-02T08-14-16-019c1e7d-54e4-7bf0-bcc5-bf98a1426b57.jsonl
        │           │   ├── rollout-2026-02-02T08-14-25-019c1e7d-7989-7da2-99b2-2687b27463cd.jsonl
        │           │   ├── rollout-2026-02-02T08-44-36-019c1e99-1ce9-7f32-82be-a22ca069309b.jsonl
        │           │   ├── rollout-2026-02-02T08-58-50-019c1ea6-2256-7c63-b695-784a686f14cc.jsonl
        │           │   ├── rollout-2026-02-02T12-38-05-019c1f6e-de91-7b92-8c6b-47f892d2025c.jsonl
        │           │   ├── rollout-2026-02-02T16-35-28-019c2048-314b-7193-9e25-c2c8417c08f4.jsonl
        │           │   ├── rollout-2026-02-02T17-18-43-019c206f-cb2a-75e2-bc38-08e865890fed.jsonl
        │           │   ├── rollout-2026-02-02T17-31-05-019c207b-1ccd-7c72-b64d-d33d9a9bd789.jsonl
        │           │   ├── rollout-2026-02-02T17-47-55-019c208a-881b-7353-8eb5-9da9b93ca036.jsonl
        │           │   ├── rollout-2026-02-02T20-31-39-019c2120-705e-7052-ae04-061543cbfbfa.jsonl
        │           │   ├── rollout-2026-02-02T21-21-12-019c214d-cc07-7c43-b4a5-460d60ccef5f.jsonl
        │           │   ├── rollout-2026-02-02T21-27-51-019c2153-e3f1-7590-b637-1a89b3c41099.jsonl
        │           │   ├── rollout-2026-02-02T21-34-11-019c2159-af9a-7ad2-8adb-f7e6831ab2d9.jsonl
        │           │   ├── rollout-2026-02-02T21-40-59-019c215f-e8b8-77a3-87cc-2b749327a4cf.jsonl
        │           │   ├── rollout-2026-02-02T22-00-50-019c2172-15fe-78e0-a1d1-bdef057c5b81.jsonl
        │           │   ├── rollout-2026-02-02T22-10-28-019c217a-e658-7e30-bc24-27bc48eb37b3.jsonl
        │           │   └── rollout-2026-02-02T22-16-44-019c2180-a4b8-7402-bd7e-091a8ca66d71.jsonl
        │           └── 03
        │               ├── rollout-2026-02-03T08-07-54-019c239d-dfbd-7430-9733-c6ab144fd6c2.jsonl
        │               ├── rollout-2026-02-03T08-27-58-019c23b0-3ede-7c30-9e80-bc0c83798a45.jsonl
        │               ├── rollout-2026-02-03T09-24-19-019c23e3-d527-7ee2-bb5e-805dca81b6f5.jsonl
        │               ├── rollout-2026-02-03T10-09-10-019c240c-e489-7c92-8a6b-ecfdbdd70757.jsonl
        │               ├── rollout-2026-02-03T10-28-48-019c241e-de05-7b22-8f93-f9fe46d23af0.jsonl
        │               ├── rollout-2026-02-03T17-40-49-019c25aa-63f8-7a72-a2b3-9b8dabb9d05e.jsonl
        │               ├── rollout-2026-02-03T17-59-49-019c25bb-c8e1-7491-8159-9621a1c8c0eb.jsonl
        │               ├── rollout-2026-02-03T18-22-00-019c25d0-18b7-7852-9a2d-100393029130.jsonl
        │               └── rollout-2026-02-03T21-20-46-019c2673-c3e8-7932-bab7-47a8408fd06f.jsonl
        ├── skills
        ├── tmp
        │   └── path
        │       ├── codex-arg0aerh3H
        │       │   ├── apply_patch -> /opt/homebrew/bin/codex
        │       │   └── applypatch -> /opt/homebrew/bin/codex
        │       ├── codex-arg0E3I0wz
        │       │   ├── apply_patch -> /opt/homebrew/bin/codex
        │       │   └── applypatch -> /opt/homebrew/bin/codex
        │       ├── codex-arg0F4msT7
        │       │   ├── apply_patch -> /opt/homebrew/bin/codex
        │       │   └── applypatch -> /opt/homebrew/bin/codex
        │       ├── codex-arg0jhxouo
        │       │   ├── apply_patch -> /Users/pgollucci/.vscode-sandboxes/P6/extensions/openai.chatgpt-0.4.66-darwin-arm64/bin/macos-aarch64/codex
        │       │   └── applypatch -> /Users/pgollucci/.vscode-sandboxes/P6/extensions/openai.chatgpt-0.4.66-darwin-arm64/bin/macos-aarch64/codex
        │       ├── codex-arg0JsYtgQ
        │       │   ├── apply_patch -> /opt/homebrew/bin/codex
        │       │   └── applypatch -> /opt/homebrew/bin/codex
        │       ├── codex-arg0ObGmHy
        │       │   ├── apply_patch -> /opt/homebrew/bin/codex
        │       │   └── applypatch -> /opt/homebrew/bin/codex
        │       └── codex-arg0ycx8mF
        │           ├── apply_patch -> /Users/pgollucci/.vscode/extensions/openai.chatgpt-0.4.66-darwin-arm64/bin/macos-aarch64/codex
        │           └── applypatch -> /Users/pgollucci/.vscode/extensions/openai.chatgpt-0.4.66-darwin-arm64/bin/macos-aarch64/codex
        └── version.json

25 directories, 84 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
