
This is is an experimental build of [haskell/haskell-language-server](https://github.com/haskell/haskell-language-server#readme).

# Installation

The cachix step is optional but highly recommended, to avoid some 2h of compilation.

### Linux, macOS: installation as user

    $ nix-env -iA cachix -f https://cachix.org/api/v1/install
    $ cachix use hercules-ci
    $ nix-env -iA ghc-8_6_5.ghcide -f https://github.com/hercules-ci/haskell-language-server.nix/tarball/master

### NixOS global installation

    $ sudo nix-env -iA cachix -f https://cachix.org/api/v1/install
    $ sudo cachix use --nixos hercules-ci

`configuration.nix`:

    environment.systemPackages = [
      (import (builtins.fetchTarball "https://github.com/hercules-ci/haskell-language-server.nix/tarball/master") {}).ghc-8_6_5.ghcide
    ];

# Configuration and usage

See [upstream instructions](https://github.com/haskell/haskell-language-server#readme)
