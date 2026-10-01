{
  description = "
    Tauri 2 项目
    初始化命令：nix flake init -t github:bingo-h/nix-libs#<模板名>

    更新命令：nix flake update (拉取远程仓库配置修改)
    构建包：nix build .#default
    修改了 devShell 开发环境配置：nix develop (如果配置了 direnv 和 .envrc 的 use flake 会自动 reload)
  ";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-libs = {
      url = "github:bingo-h/nix-libs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      nix-libs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = nix-libs.lib.mkTauriShell {
        inherit pkgs rust-overlay;

        # extraBuildInputs = with pkgs; [ ];

        # crossSystems = [
        #     nixpkgs.lib.systems.examples.aarch64-multiplatform
        #     nixpkgs.lib.systems.examples.wasm32
        # ];
      };

      packages.${system}.default =
        let
          src = pkgs.lib.cleanSource self;
          # src = pkgs.lib.cleanSource ./.;
          # src = pkgs.fetchFromGitHub {
          #   owner = "Github Username";
          #   repo = "repo-name";
          #   rev = "v0.1.0";
          #   hash = pkgs.lib.fakeHash;
          # };

          cargoToml = fromTOML (builtins.readFile "${src}/src-tauri/Cargo.toml");
        in
        nix-libs.lib.mkTauriPackage {
          inherit pkgs src;
          pname = cargoToml.package.name; # 修改为项目包名称
          version = cargoToml.package.version;

          srcTauriDir = "src-tauri";
          frontendDir = "frontend";

          # 第一次先用 fakeHash 跑,拿到真实哈希后替换
          pnpmDepsHash = pkgs.lib.fakeHash;
          # pnpmDepsHash = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=";
        };
    };
}
