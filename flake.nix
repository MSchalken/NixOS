{
  description = "NixOS configuration for MSchalken";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ { self, home-manager, nixpkgs, ... }:

  with inputs;
  let
    username = "mschalken";
    hostname = "nixos";
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
    wsl-system = import ./system/wsl.nix {
      inherit inputs username hostname secrets;
    };
  in 

  {
    nixosConfigurations = {
      # aarch64 = nixos-system "aarch64-linux";
      # x86_64 = nixos-system "x86_64-linux";
      wsl = wsl-system "x86_64-linux";
    };
  };
}
