{
  pkgs,
  pname,
  version,
  src,
  srcTauriDir ? "src-tauri",
  frontendDir ? "frontend",
  pnpmDepsHash,
  desktopName ? pname,
  desktopComment ? "",
  desktopCategories ? [ "Utility" ],
  iconFile ? "${srcTauriDir}/icons/128x128.png", # Tauri 默认脚手架自带这份
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraArgs ? { },
}:
let
  mkRustPackage = import ./mkRustPackage.nix;

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit pname;
    src = "${src}/${frontendDir}";
    fetcherVersion = 4;
    hash = pnpmDepsHash;
  };
in
mkRustPackage {
  inherit
    pkgs
    pname
    version
    src
    ;

  cargoLockFile = "${src}/${srcTauriDir}/Cargo.lock";

  extraNativeBuildInputs =
    with pkgs;
    [
      nodejs
      pnpm
      pnpmConfigHook
      copyDesktopItems
      wrapGAppsHook3
    ]
    ++ extraNativeBuildInputs;

  extraBuildInputs =
    with pkgs;
    [
      pkg-config
      gtk3
      dbus
      atk
      webkitgtk_4_1
    ]
    ++ extraBuildInputs;

  extraArgs = {
    cargoRoot = srcTauriDir;
    buildAndTestSubdir = srcTauriDir;

    inherit pnpmDeps;
    pnpmRoot = frontendDir;

    preBuild = ''
      (
        cd ${frontendDir}
        pnpm run build
      )
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = desktopName;
        comment = desktopComment;
        categories = desktopCategories;
      })
    ];

    postInstall = ''
      install -Dm644 ${iconFile} $out/share/icons/hicolor/128x128/apps/${pname}.png
    '';
  }
  // extraArgs;
}
