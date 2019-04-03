with import <nixpkgs> {};

let
  env = haskellPackages.ghcWithPackages (p: [ (p.callPackage ./foracosta.nix {}) ]);
in
stdenv.mkDerivation rec {
  name = "env";
  buildInput = [
    env
  ];
  shellHook = ''
  ghci
  '';
}
