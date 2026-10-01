{
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
      devShells.${system}.default = nix-libs.lib.mkRustShell {
        inherit pkgs rust-overlay;

        extraBuildInputs = with pkgs; [ ];

        # crossSystems = [
        #     nixpkgs.lib.systems.examples.aarch64-multiplatform
        #     nixpkgs.lib.systems.examples.wasm32
        # ];
      };
    };
}
