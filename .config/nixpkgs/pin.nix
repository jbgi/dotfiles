let
  pkgs = import <nixpkgs> { config.allowUnfree = true;};
  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };
in
  import src {}
