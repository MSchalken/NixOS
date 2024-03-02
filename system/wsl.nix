{ inputs, username, hostname }:

system:

let
  wsl-config = import ../module/wsl-config.nix;
  home-manager = import ../module/home-manager.nix;
in

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = { inherit username hostname; };

  modules = [

    # Load wsl modules
    inputs.nixos-wsl.nixosModules.wsl

    # Define wsl specific system configuration
    wsl-config

    # Setup home manager
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = home-manager;
      home-manager.extraSpecialArgs = { inherit username; };
    }
  ];
}
