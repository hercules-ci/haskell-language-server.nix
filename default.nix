# Build checks.sets by default. This has the project-specific build products.
# nix/ci.nix performs all checks.
{ pkgs ? import ./nix {} }:
pkgs.project.checks.sets
