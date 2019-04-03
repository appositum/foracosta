{ mkDerivation, base, containers, megaparsec, stdenv }:
mkDerivation {
  pname = "foracosta";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base containers megaparsec ];
  executableHaskellDepends = [ base containers megaparsec ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/appositum/foracosta#readme";
  license = stdenv.lib.licenses.bsd3;
}
