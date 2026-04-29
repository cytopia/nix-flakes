{
  description = "Custom Devbox Tools Registry";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          # --- Terraform v1.1.0 ---
          "terraform-1-1-0" = pkgs.stdenv.mkDerivation {
            pname = "terraform";
            version = "1.1.0";
            src = pkgs.fetchurl (
              if system == "x86_64-linux" then {
                url = "https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip";
                sha256 = "sha256-djN4qnVQDOW6Z9DLqKpgVnDNKL+Lr8cJMzowkIRBrLU=";
              } else if system == "aarch64-linux" then {
                url = "https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_arm64.zip";
                sha256 = "sha256-mXzWvB0K2rL4p5Vw7v8fWp7z9u1y9v9w9v9v9v9v9v8=";
              } else if system == "x86_64-darwin" then {
                url = "https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_darwin_amd64.zip";
                sha256 = "sha256-fUvU+G9vY8v7v6v5v4v3v2v1v0v9v8v7v6v5v4v3v2o=";
              } else { # aarch64-darwin
                url = "https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_darwin_arm64.zip";
                sha256 = "sha256-D7G05zU9wz7mP6RkL9uM+y3xX7T6QoZ4fE8rD9K2n7M=";
              }
            );
            nativeBuildInputs = [ pkgs.unzip ];
            unpackPhase = "unzip $src";
            installPhase = ''
              mkdir -p $out/bin
              cp terraform $out/bin/terraform
              chmod +x $out/bin/terraform
            '';
          };

          # --- Terragrunt v0.98.0 ---
          "terragrunt-0-98-0" = pkgs.stdenv.mkDerivation {
            pname = "terragrunt";
            version = "0.98.0";
            src = pkgs.fetchurl (
              if system == "x86_64-linux" then {
                url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.98.0/terragrunt_linux_amd64";
                sha256 = "68a9e029b438957c4164e505dfade123c67d6c3c3e11880bcadf3f2b33a8d865";
              } else if system == "aarch64-linux" then {
                url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.98.0/terragrunt_linux_arm64";
                sha256 = "3568940feeef791cf6302b2fe324de3562580e5a7dfbb260b2a8a9569225cb08";
              } else if system == "x86_64-darwin" then {
                url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.98.0/terragrunt_darwin_amd64";
                sha256 = "9d8678cee9fe1db3df9383196e90f6723338b56a54b77cec6edc67f76dc8cda4";
              } else { # aarch64-darwin
                url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.98.0/terragrunt_darwin_arm64";
                sha256 = "d3999397b1e77ab9dddaedef1157e58da2454cbc74528ee5221c4916ccdba1e5";
              }
            );
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/terragrunt
              chmod +x $out/bin/terragrunt
            '';
          };
          # ---- Terragrunt Atlantis Config v1.21.1
          "terragrunt-atlantis-config-1-21-1" = pkgs.stdenv.mkDerivation {
            pname = "terragrunt-atlantis-config";
            version = "1.21.1";
            src = pkgs.fetchurl (
              if system == "x86_64-linux" then {
                url = "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v1.21.1/terragrunt-atlantis-config_1.21.1_linux_amd64";
                sha256 = "1303113ca64edff78f0861d53eea680552bf79729b3ec605f1f4ed8b81b5a37b";
              } else { # aarch64-darwin
                url = "";
                sha256 = "";
              }
            );
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/terragrunt-atlantis-config
              chmod +x $out/bin/terragrunt-atlantis-config
            '';
          };
        }
      );
    };
}
