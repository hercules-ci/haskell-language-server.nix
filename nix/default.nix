{ sources ? import ./sources.nix
, nixpkgs ? sources.nixpkgs
, system ? builtins.currentSystem
}:
let
  overlay = self: super: {
    project-nix = import sources."project.nix" { inherit (self) lib; };
    project-eval =
      self.project-nix.evalProject {
        modules = [
          { nixpkgs.pkgs = self; }
          ./project.nix
        ];
      };
    project = self.project-eval.config;
  };
in
import nixpkgs {
  config = {};
  overlays = [
    overlay
  ];
  inherit system;
}
