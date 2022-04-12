{
  description = "linear-import-nix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      allSystems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" ];

      forAllSystems = f: genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShell = forAllSystems ({ system, pkgs, ... }:
        pkgs.mkShell {
          name = "linear-import";

          buildInputs = with pkgs; [
            nixpkgs-fmt
            findutils # find, xargs
            codespell
            nodePackages.node2nix
          ] ++ [
            self.defaultPackage.${system}
          ];
        });

      packages = forAllSystems
        ({ system, pkgs, ... }: {
          linear-import = pkgs.callPackage ./import.nix {
            inherit (import ./default.nix { inherit pkgs; })
              nodeDependencies;
          };
        });

      defaultPackage = forAllSystems ({ system, ... }: self.packages.${system}.linear-import);
    };
}
