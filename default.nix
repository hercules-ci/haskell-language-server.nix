# Build checks.sets by default. This has the project-specific build products.
# nix/ci.nix performs all checks.
{ project ? import ./nix {} }:
project.checks.sets
