{
  pkgs,
  rust-overlay,
  crossSystems ? [ ],
  extraBuildInputs ? [ ],
}:
let
  mkRustShell = import ./mkRustShell.nix;
in
mkRustShell {
  inherit pkgs rust-overlay crossSystems;

  extraBuildInputs =
    with pkgs;
    [
      pkg-config
      gtk3
      dbus
      atk
      webkitgtk_4_1
      cargo-tauri
    ]
    ++ extraBuildInputs;
}
