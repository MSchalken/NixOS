{
  # Generic system settings
  nix = {
    settings = {
      # Enable nix flakes
      experimental-features = [ "nix-command" "flakes" ];

      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      warn-dirty = false;

      # Setup build cache
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

  programs.zsh.enable = true;
}
