let
  sources = import ./sources.nix;
  inherit (import (sources."project.nix" + "/lib/dimension.nix") { lib = import (sources.nixpkgs + "/lib"); })
    dimension
    ;

in
dimension "System" {
  "x86_64-linux" = {};
  "x86_64-darwin" = {};
} (
  system: {}:
    (
      import ./default.nix {
        extraModules = [
          {
            nixpkgs.system = system;
          }
        ];
      }
    ).checks
)
