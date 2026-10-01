# nix-libs

个人项目通用的 Nix flake 工具库：Rust / Tauri 项目的开发环境与打包封装，以及对应的项目模板。

## lib

- `mkRustShell`：Rust 项目的开发环境（`devShell`），基于 `rust-overlay`。
- `mkRustPackage`：基于 `buildRustPackage` 的 Rust 包封装。
- `mkTauriShell`：在 `mkRustShell` 基础上补齐 Tauri 2 所需的系统依赖（gtk3/webkitgtk 等）。
- `mkTauriPackage`：在 `mkRustPackage` 基础上补齐前端（pnpm）构建、desktop 文件、图标安装等 Tauri 2 打包步骤。

用法示例：

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-libs = {
      url = "github:bingo-h/nix-libs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, nix-libs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = nix-libs.lib.mkTauriShell {
        inherit pkgs rust-overlay;
      };

      packages.${system}.default = nix-libs.lib.mkTauriPackage {
        inherit pkgs;
        src = pkgs.lib.cleanSource self;
        pname = "my-app";
        version = "0.1.0";
        pnpmDepsHash = pkgs.lib.fakeHash; # 先用 fakeHash 跑一次拿到真实哈希再替换
      };
    };
}
```

## templates

```sh
nix flake init -t github:bingo-h/nix-libs#rust   # 普通 Rust 项目
nix flake init -t github:bingo-h/nix-libs#tauri  # Tauri 2 项目
```
