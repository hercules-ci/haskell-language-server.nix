{ lib, config, sets, defaultSources, sources, ... }:
let
  pkgs = config.nixpkgs.pkgs;
  haskell-language-server-source = pkgs.fetchgit
    (builtins.removeAttrs (builtins.fromJSON (builtins.readFile ./haskell-language-server.json)) [ "date" ]);
  defaults = {
    configuration.packages.ghc.flags.ghci = lib.mkForce true;
    configuration.packages.ghci.flags.ghci = lib.mkForce true;
    configuration.reinstallableLibGhc = true;
    # This fixes a performance issue, probably https://gitlab.haskell.org/ghc/ghc/issues/15524
    configuration.packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];

    # fixme: how to override a haskell.nix option?
    configuration.packages.shake.src = lib.mkForce (
      builtins.fetchGit {
        url = "https://github.com/wz1000/shake.git";
        rev = "fb3859dca2e54d1bbb2c873e68ed225fa179fbef";
        ref = "no-scheduler";
      }
    );
  };
in
{
  imports = [
    (defaultSources."pre-commit-hooks.nix" + "/nix/project-module.nix")
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
        # Fixups
        # https://hercules-ci.com/accounts/github/hercules-ci/derivations/%2Fnix%2Fstore%2Fn7ik6fbxl50824qylsk0kh35q3f7k3sz-cabal-helper-1.0.0.0-lib-c-h-internal.drv/log?via-job=167a65a4-f7d0-412c-9b70-f030456ed1dd
        configuration.packages.cabal-helper.components.sublibs.c-h-internal.doHaddock = false;
      }
    ];
  packageSets.haskell-nix."ghc-8_8_2" =
    lib.mkMerge [
      defaults
      {
        stackYaml = haskell-language-server-source + "/stack-8.8.2.yaml";
        # Fixups
        configuration.nonReinstallablePkgs = [ "Cabal" ];
      }
    ];
  packageSets.haskell-nix."ghc-8_8_3" =
    lib.mkMerge [
      defaults
      {
        stackYaml = haskell-language-server-source + "/stack-8.8.3.yaml";
        # Fixups
        configuration.nonReinstallablePkgs = [ "Cabal" ];
      }
    ];
  pre-commit.enable = true;
  pre-commit.hooks.nixpkgs-fmt.enable = true;

  # TODO upstream this
  pre-commit.package = pkgs.gitAndTools.pre-commit;

}
