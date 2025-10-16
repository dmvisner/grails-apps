{
  description = "Development environments for Grails apps";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-maven.url = "github:NixOS/nixpkgs/79cb2cb9869d7bb8a1fac800977d3864212fd97d";
    nixpkgs-node.url = "github:NixOS/nixpkgs/54c1e44240d8a527a8f4892608c4bce5440c3ecb";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-maven,
    nixpkgs-node,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        maven = nixpkgs-maven.legacyPackages.${system}.maven;
        node = nixpkgs-node.legacyPackages.${system}.nodejs-10_x;
        grails244 = pkgs.stdenv.mkDerivation {
          name = "grails-2.4.4";
          src = pkgs.fetchzip {
            url = "https://github.com/grails/grails-core/releases/download/v2.4.4/grails-2.4.4.zip";
            sha256 = "sha256-ChOZa1eWIPoGQxhNipJOIPyjQWvUWM9POiiHkjVqp7s=";
          };
          installPhase = ''
            mkdir -p $out
            cp -r * $out/
            chmod +x $out/bin/grails
          '';
        };
        grails245 = pkgs.stdenv.mkDerivation {
          name = "grails-2.4.5";
          src = pkgs.fetchzip {
            url = "https://github.com/grails/grails-core/releases/download/v2.4.5/grails-2.4.4.zip";
            sha256 = "sha256-U93rR7AouzyN/uj1RTx/o5Ehaw/XLwxFxN7Vdh0xtAc=";
          };
          installPhase = ''
            mkdir -p $out
            cp -r * $out/
            chmod +x $out/bin/grails
          '';
        };
      in {
        devShells = {
          account-ui = pkgs.mkShell {
            buildInputs = [pkgs.jdk8 maven grails245];
          };
          trip-management = pkgs.mkShell {
            buildInputs = [pkgs.jdk8 maven grails244 node];
            shellHook = ''
              chmod -R +x ./angularSpec/lib/node/ 2>/dev/null || true
            '';
          };
        };
      }
    );
}
