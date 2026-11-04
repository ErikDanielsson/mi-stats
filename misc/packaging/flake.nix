{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    miking.url = "github:miking-lang/miking?dir=misc/packaging";
    miking.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, miking }:
    let
      mkPkg = system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.pkgs;
          mpkgs = miking.packages.${system};
        in
        rec {
          packages.mi-stats = pkgs.callPackage ./mi-stats.nix {};
          packages.default = packages.mi-stats;
          devShells.default = pkgs.mkShell {
            name = "mi-stats dev shell";
            inputsFrom = [ packages.mi-stats ];
            # `mi` (and `miking-lib`'s MCORE_LIBS hook) for `make test`,
            # `fish`, `git` and `rsync` for `make vendor`
            buildInputs = [ mpkgs.miking mpkgs.miking-lib pkgs.fish pkgs.git pkgs.rsync ];
          };
        };
    in
      flake-utils.lib.eachDefaultSystem mkPkg // rec {
        overlays.mi-stats = final: prev: {
          mi-stats = final.callPackage ./mi-stats.nix {};
        };
        overlays.default = overlays.mi-stats;
      };
}
