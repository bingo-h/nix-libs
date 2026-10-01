{
  description = "H.Bin 的公开 Nix 工具库：Rust/Tauri 项目的开发环境与打包封装、项目模板";

  outputs = { self }: {
    lib = {
      mkRustShell = import ./lib/mkRustShell.nix;
      mkRustPackage = import ./lib/mkRustPackage.nix;
      mkTauriShell = import ./lib/mkTauriShell.nix;
      mkTauriPackage = import ./lib/mkTauriPackage.nix;
    };

    templates = {
      rust = {
        path = ./templates/rust-dev;
        description = "普通 Rust 项目开发环境";
      };

      tauri = {
        path = ./templates/rust-tauri;
        description = "Tauri 2 项目，包含了开发环境和打包的模板";
      };
    };
  };
}
