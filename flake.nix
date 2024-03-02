{
  description = "NixOS Configuration for MSchalken";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      username = "mschalken";
      hostname = "nixos";

      wsl-system = import ./system/wsl.nix {
        inherit inputs username hostname;
      };
    in
    {
      nixosConfigurations = {
        wsl = wsl-system "x86_64-linux";
      };
    };
}
