{
  pkgs,
  rust-overlay,
  crossSystems ? [ ],
  extraBuildInputs ? [ ],
}:

let
  overlays = [ rust-overlay.overlays.default ];
  pkgs' = import pkgs.path {
    inherit (pkgs) system;
    inherit overlays;
  };

  pkgsCrossList = map (
    cs:
    import pkgs.path {
      inherit (pkgs) system;
      inherit overlays;
      crossSystem = cs;
    }
  ) crossSystems;

  rustToolchain = pkgs'.rust-bin.stable.latest.default.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
      "clippy"
      "rustfmt"
    ];
    targets = map (cs: cs.config) crossSystems;
  };

  # 每个crossSystem对应生成一条linker环境变量
  linkerEnvs = builtins.listToAttrs (
    map (pkgsCross: {
      name = "CARGO_TARGET_${
        pkgs.lib.toUpper (builtins.replaceStrings [ "-" ] [ "_" ] pkgsCross.stdenv.targetPlatform.config)
      }_LINKER";
      value = "${pkgsCross.stdenv.cc}/bin/${pkgsCross.stdenv.cc.targetPrefix}cc";
    }) pkgsCrossList
  );

  crossBuildInputs = map (pkgsCross: pkgsCross.stdenv.cc) pkgsCrossList;

in
pkgs'.mkShell (
  {
    buildInputs = [ rustToolchain ] ++ extraBuildInputs ++ crossBuildInputs;
    RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
  }
  // linkerEnvs
)
