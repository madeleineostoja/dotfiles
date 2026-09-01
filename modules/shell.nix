{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.worktrunk ];

  home.sessionVariables = {
    EDITOR = "fresh";
    VISUAL = "fresh";
    GH_COLOR_LABELS = "1";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    RG_COLORS = lib.concatStringsSep ":" [
      "path:fg:0x8a,0xad,0xf4"
      "line:fg:0xa6,0xda,0x95"
      "column:fg:0xee,0xd4,0x9f"
      "match:fg:0xed,0x87,0x96"
      "match:style:bold"
    ];
  };

  catppuccin.zsh-syntax-highlighting.enable = false;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#6e738d";
    };
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    profileExtra = ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

    shellAliases = {
      # Tool swaps
      cat = "bat --paging=never";
      less = "bat";
      ls = "eza --group-directories-first";
      ll = "eza -la --group-directories-first --git";
      tree = "eza --tree --level=2";

      # Convenience
      c = "clear";
      fr = "fresh";
      rmf = "rm -rf";
      pn = "pnpm";
      z = "zed";
      piup = "pi update && pi update --extensions";

      # Git
      g = "git";
      lg = "lazygit";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      glog = "git log --graph";
      gpull = "git pull";
      grpull = "git fetch && git rebase";
      gpush = "git push";
      gpushf = "git push --force-with-lease --force-if-includes";
      grecommit = "git commit --amend -C HEAD";
      gcp = "git cherry-pick";
      gf = "git fetch";
      grmb = "git branch -D";
      gbclean = "git branch --merged main | grep -v '^[* ]*main$' | xargs -r git branch -d";
    };

    initContent = ''
      if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      eval "$(${lib.getExe pkgs.worktrunk} config shell init zsh)"

      setopt AUTO_CD INTERACTIVE_COMMENTS EXTENDED_GLOB NO_BEEP
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$nix_shell$container$cmd_duration$status$line_break$character";
      character = {
        success_symbol = "[❯](peach)";
        error_symbol = "[❯](red)";
      };
      directory = {
        style = "bold lavender";
        read_only = " 󰌾";
      };
      git_branch = {
        style = "bold mauve";
        symbol = " ";
      };
      git_commit.tag_symbol = "  ";
      git_status.disabled = true;
      package.symbol = "󰏗 ";
      nodejs.symbol = "󰎙 ";
      python.symbol = " ";
      ruby.symbol = " ";
      nix_shell.symbol = " ";
      docker_context.symbol = " ";
      container.symbol = " ";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "26";
        pnpm = "11";
        python = "latest";
        "npm:sentry" = "latest";
        "npm:@earendil-works/pi-coding-agent" = "latest";
      };
    };
  };
}
