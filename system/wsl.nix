{ inputs, username, hostname, secrets, ... }: 

system:

let
  nixpkgs = inputs.nixpkgs;
  nix-index-database = inputs.nix-index-database;
  pkgs = inputs.nixpkgs;
  nixos-wsl = inputs.nixos-wsl;
  system-config = import ../module/configuration.nix;
  home-config = import ../module/home.nix;
  win32yank = import ../module/win32yank.nix { inherit pkgs; };
in 

inputs.nixpkgs.lib.nixosSystem
{
  inherit system;
  
  modules = [

    # Load wsl modules
    nixos-wsl.nixosModules.wsl
    
    # Define wsl specific system configuration
    {
      system.stateVersion = "22.05";
      time.timeZone = "Europe/Amsterdam";

      networking.hostName = "${hostname}";

      systemd.tmpfiles.rules = [
        "d /home/${username}/.config 0755 ${username} users"
      ];

      programs.zsh.enable = true;

      environment.pathsToLink = ["/share/zsh"];
      # environment.shells = [ pkgs.zsh ];
      environment.enableAllTerminfo = true;
      environment.systemPackages = [ 
        # win32yank 
      ];

      # security.sudo.enable = true;
      security.sudo.wheelNeedsPassword = false;

      # users.mutableUsers = false;
      users.users.${username} = {
        isNormalUser = true;
        home = "/home/${username}";
        # shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
      };

      wsl = {
        enable = true;
        wslConf.automount.root = "/mnt";
        wslConf.interop.appendWindowsPath = false;
        wslConf.network.generateHosts = false;
        defaultUser = username;
        startMenuLaunchers = true;
      };
    }

    # Load generic system configuration
    system-config

    # Setup home manager
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."${username}" = home-config;
        extraSpecialArgs = {
          inherit secrets inputs nix-index-database hostname username;
          channels = { inherit nixpkgs; };
        };
      };
    }
  ];
}
