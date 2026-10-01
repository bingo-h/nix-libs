{
  pkgs,
  pname,
  version,
  src,
  cargoLockFile ? "${src}/Cargo.lock",
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraArgs ? { },
}:
pkgs.rustPlatform.buildRustPackage (
  {
    inherit pname version src;

    cargoLock = {
      lockFile = cargoLockFile;
    };

    nativeBuildInputs = with pkgs; [ pkg-config ] ++ extraNativeBuildInputs;

    buildInputs = with pkgs; [ openssl ] ++ extraBuildInputs;

    doCheck = false;
  }
  // extraArgs
)
