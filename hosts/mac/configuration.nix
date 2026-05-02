{
  pkgs,
  username,
  hostname,
  ...
}:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "claude-code"
      "terraform"
    ];

  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@admin"
        username
      ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      interval = {
        Weekday = 7;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
  };

  networking.hostName = hostname;
  networking.localHostName = hostname;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  programs.zsh.enable = true;

  environment.shells = with pkgs; [
    zsh
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system = {
    primaryUser = username;
    stateVersion = 6;

    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
