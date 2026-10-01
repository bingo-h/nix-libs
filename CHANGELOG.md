# Changelog

## [未发布]

### 新增

- 仓库初始化：从私有仓库 `nix-config` 的 `lib/`（`mkRustShell.nix`/`mkRustPackage.nix`/`mkTauriShell.nix`/`mkTauriPackage.nix`）和 `templates/`（`rust-dev`、`rust-tauri`）拆分出来，作为独立的公开 Nix flake 工具库。新增根 `flake.nix`，输出 `lib.{mkRustShell,mkRustPackage,mkTauriShell,mkTauriPackage}` 和 `templates.{rust,tauri}`。
- `templates/rust-dev/flake.nix`、`templates/rust-tauri/flake.nix` 里原本指向私有仓库 `nix-config`（`git+ssh://...`）的 input 改名为 `nix-libs`，地址改成 `github:bingo-h/nix-libs`，`nix-config.lib.*` 调用相应改成 `nix-libs.lib.*`，这样别人直接用公开地址就能跑模板，不需要私有仓库的 SSH 访问权限。
