{
  pkgs,
  username,
  configurationName,
  ...
}:

let
  direnvNoCheck = pkgs.direnv.overrideAttrs (_: {
    doCheck = false;
    doInstallCheck = false;
  });
in

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    argocd
    bat
    bottom
    buf
    claude-code
    codex
    delta
    docker-client
    docker-compose
    emacs-nox
    eza
    fd
    fzf
    gh
    ghq
    git
    go_1_26
    gopls
    golangci-lint
    google-cloud-sdk
    grpcurl
    jq
    jujutsu
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    lefthook
    mise
    nil
    nixfmt-rfc-style
    ncurses
    nodejs_24
    pnpm
    protobuf
    pyright
    python3
    ripgrep
    ruff
    terraform
    terraform-ls
    tflint
    tig
    tree
    uv
    silver-searcher
    vim
    wget
    yq-go
    zoxide
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER = "less";
    TERMINFO_DIRS = "${pkgs.ncurses}/share/terminfo:${pkgs.kitty.terminfo}/share/terminfo:${pkgs.wezterm.terminfo}/share/terminfo:/usr/share/terminfo";
  };

  home.file.".config/zsh/functions/ghq-fzf-cd".source = ./zsh/functions/ghq-fzf-cd;

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
      rebuild = "sudo darwin-rebuild switch --flake ~/ghq/github.com/ozw-sei/nix-config#${configurationName}";
    };

    initContent = ''
      if [[ -o interactive ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
        export TERM=xterm-256color
      fi

      fpath=("$HOME/.config/zsh/functions" "''${fpath[@]}")
      autoload -Uz ghq-fzf-cd
      zle -N ghq-fzf-cd
      bindkey '^[;' ghq-fzf-cd

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
