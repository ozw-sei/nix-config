{ pkgs, username, configurationName, ... }:

let
  direnvNoCheck = pkgs.direnv.overrideAttrs (_: {
    doCheck = false;
  });
in

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    bat
    bottom
    claude-code
    codex
    delta
    emacs
    eza
    fd
    fzf
    gh
    git
    go
    gopls
    golangci-lint
    jq
    jujutsu
    nil
    nixfmt-rfc-style
    pyright
    python3
    ripgrep
    ruff
    tig
    tree
    uv
    tig
    ripgrep
    silver-searcher
    vim
    wget
    zoxide
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER = "less";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
      include.path = "~/.config/git/config.local";
    };
    ignores = [
      ".DS_Store"
      ".direnv/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cat = "bat";
      grep = "rg";
      ls = "eza --icons=auto";
      ll = "eza -lah --icons=auto --git";
      rebuild = "sudo darwin-rebuild switch --flake ~/Documents/Codex/2026-05-01/mac-nix#${configurationName}";
    };

    initContent = ''
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    package = direnvNoCheck;
    nix-direnv.enable = true;
  };
}
