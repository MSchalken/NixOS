{ pkgs, username, hostname, ... }:

{
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Amsterdam";
  networking.hostName = "${hostname}";

  systemd.tmpfiles.rules = [
    "d /home/${username}/.config 0755 ${username} users"
  ];

  security.sudo.wheelNeedsPassword = false;

  environment.enableAllTerminfo = true;
  environment.systemPackages = [
    (import ../module/win32yank.nix { inherit pkgs; })
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = [ pkgs.zsh ];

  users.users."${username}" = {
    extraGroups = [ "wheel" ];
    home = "/home/${username}";
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;

      builders-use-substitutes = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
