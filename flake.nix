{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    swift.url = "github:dduan/swift-builders";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, swift, flake-utils }:
    with swift.lib;
    flake-utils.lib.eachSystem swiftPlatforms (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      package = "TOMLDecoder";
      version = "0.4.2";
      src = ./.;
    in
    rec {
      packages = rec {
        Deserializer = mkDynamicLibrary pkgs {
          inherit version src package;
          target = "Deserializer";
        };
        TOMLDecoder = mkDynamicLibrary pkgs {
          inherit version src package;
          target = "TOMLDecoder";
          buildInputs = [ Deserializer ];
        };
      };
      defaultPackage = packages.TOMLDecoder;
    }
    );
}
