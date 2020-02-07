{ lib, pkgs, sets, ... }:
let
  sources = import ./sources.nix;
  haskell-language-server-source = pkgs.fetchgit {
    inherit (builtins.fromJSON (builtins.readFile ./haskell-language-server.json))
      url sha256 fetchSubmodules
      ;
  };
  defaults = {
    cfg.packages.ghc.flags.ghci = pkgs.lib.mkForce true;
    cfg.packages.ghci.flags.ghci = pkgs.lib.mkForce true;
    cfg.reinstallableLibGhc = true;
    # This fixes a performance issue, probably https://gitlab.haskell.org/ghc/ghc/issues/15524
    cfg.packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];
  };
in
{
  imports = [
    (sources."pre-commit-hooks.nix" + "/nix/project-module.nix")
  ];
  root = ../.;
  pinning.niv.enable = true;
  shell.packages = [ pkgs.nix-prefetch-git ];

  packageSets.haskell-nix."ghc-8_6_4" =
    lib.mkMerge [
      defaults
      {
        stackYaml = haskell-language-server-source + "/stack-8.6.4.yaml";
      }
    ];
  packageSets.haskell-nix."ghc-8_6_5" =
    lib.mkMerge [
      defaults
      {
        stackYaml = haskell-language-server-source + "/stack-8.6.5.yaml";
      }
    ];
  packageSets.haskell-nix."ghc-8_8_2" =
    lib.mkMerge [
      defaults
      {
        stackYaml = haskell-language-server-source + "/stack-8.8.2.yaml";
        # Fixups
        nonReinstallablePkgs = [ "Cabal" ];
      }
    ];

  pre-commit.enable = true;
  pre-commit.hooks.nixpkgs-fmt.enable = true;

  # TODO upstream this
  pre-commit.package = pkgs.gitAndTools.pre-commit;
}
