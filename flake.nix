{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-maven.url = "github:NixOS/nixpkgs/79cb2cb9869d7bb8a1fac800977d3864212fd97d";
    nixpkgs-node10.url = "github:NixOS/nixpkgs/54c1e44240d8a527a8f4892608c4bce5440c3ecb";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-maven,
    nixpkgs-node10,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    maven = nixpkgs-maven.legacyPackages.${system}.maven;
    nodejs10 = nixpkgs-node10.legacyPackages.${system}.nodejs-10_x;
    grails = pkgs.stdenv.mkDerivation {
      name = "grails-2.4.5";
      src = pkgs.fetchzip {
        url = "https://github.com/apache/grails-core/releases/download/v2.4.5/grails-2.4.5.zip";
        sha256 = "sha256-U93rR7AouzyN/uj1RTx/o5Ehaw/XLwxFxN7Vdh0xtAc=";
      };
      installPhase = ''
        mkdir -p $out
        cp -r * $out/
        chmod +x $out/bin/grails
      '';
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [pkgs.jdk8 maven grails nodejs10];
      shellHook = ''
        export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"
        alias mvn="mvn -s $PWD/.m2/settings.xml"
      '';
    };
  };
}
