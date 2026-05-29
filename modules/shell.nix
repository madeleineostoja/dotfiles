{
  config,
  lib,
  catppuccin-bat,
  catppuccin-delta,
  catppuccin-eza,
  catppuccin-lazygit,
  ...
}:

let
  catppuccinMacchiato = {
    rosewater = "#f4dbd6";
    flamingo = "#f0c6c6";
    pink = "#f5bde6";
    mauve = "#c6a0f6";
    red = "#ed8796";
    maroon = "#ee99a0";
    peach = "#f5a97f";
    yellow = "#eed49f";
    green = "#a6da95";
    teal = "#8bd5ca";
    sky = "#91d7e3";
    sapphire = "#7dc4e4";
    blue = "#8aadf4";
    lavender = "#b7bdf8";
    text = "#cad3f5";
    subtext1 = "#b8c0e0";
    subtext0 = "#a5adcb";
    overlay2 = "#939ab7";
    overlay1 = "#8087a2";
    overlay0 = "#6e738d";
    surface2 = "#5b6078";
    surface1 = "#494d64";
    surface0 = "#363a4f";
    base = "#24273a";
    mantle = "#1e2030";
    crust = "#181926";
  };

  theme = catppuccinMacchiato;
in
{
  home.sessionVariables = {
    BAT_THEME = "Catppuccin Macchiato";
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

  xdg.configFile = {
    "eza/theme.yml".source = "${catppuccin-eza}/themes/macchiato/catppuccin-macchiato-mauve.yml";
    "git/catppuccin-delta.gitconfig".source = "${catppuccin-delta}/catppuccin.gitconfig";
  };

  home.file."Library/Application Support/lazygit/config.yml".source =
    "${catppuccin-lazygit}/themes-mergable/macchiato/mauve.yml";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=${theme.overlay0}";
    };
    syntaxHighlighting = {
      enable = true;
      styles = {
        alias = "fg=${theme.blue}";
        arg0 = "fg=${theme.blue}";
        builtin = "fg=${theme.mauve}";
        command = "fg=${theme.blue}";
        comment = "fg=${theme.overlay0}";
        double-quoted-argument = "fg=${theme.green}";
        function = "fg=${theme.blue}";
        path = "fg=${theme.teal},underline";
        precommand = "fg=${theme.mauve}";
        redirection = "fg=${theme.peach}";
        reserved-word = "fg=${theme.mauve}";
        single-quoted-argument = "fg=${theme.green}";
        unknown-token = "fg=${theme.red}";
      };
    };

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    shellAliases = {
      # Tool swaps
      cat = "bat --paging=never";
      less = "bat";
      ls = "eza --group-directories-first";
      ll = "eza -la --group-directories-first --git";
      tree = "eza --tree --level=2";

      # Convenience
      c = "clear";
      rmf = "rm -rf";
      pn = "pnpm";
      sb = "supabase";
      cc = "claude";
      z = "zed";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -m";
      gaac = "git add --all && git commit -m";
      grm = "git rm";
      gb = "git branch";
      gab = "git checkout -b";
      gcb = "git checkout";
      grmb = "git branch -D";
      grmrb = "git push origin --delete";
      grmtag = "git tag -d";
      gdis = "git checkout --";
      glog = "git log --graph";
      gpull = "git pull";
      grpull = "git fetch && git rebase";
      gpush = "git push";
      gpushf = "git push --force-with-lease --force-if-includes";
      greset = "git reset HEAD~1";
      grecommit = "git commit --amend -C HEAD";
      gcp = "git cherry-pick";
      gr = "git rebase";
      gf = "git fetch";

      # Shortcuts
      nixsync = "cd ~/dotfiles && nix flake update && home-manager switch --flake .";
      brewsync = "brew bundle install --cleanup --force --zap --file=~/dotfiles/Brewfile";
      sysupdate = "~/dotfiles/scripts/update.sh";
    };

    initContent = ''
      setopt AUTO_CD INTERACTIVE_COMMENTS EXTENDED_GLOB NO_BEEP
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      palette = "catppuccin_macchiato";
      palettes.catppuccin_macchiato = catppuccinMacchiato;
      character = {
        success_symbol = "[❯](peach)";
        error_symbol = "[❯](red)";
      };
      directory.style = "bold lavender";
      git_branch.style = "bold mauve";
      git_status.disabled = true;
      nodejs.symbol = "󰎙 ";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = theme.surface0;
      bg = theme.base;
      spinner = theme.rosewater;
      hl = theme.red;
      fg = theme.text;
      header = theme.red;
      info = theme.mauve;
      pointer = theme.rosewater;
      marker = theme.lavender;
      "fg+" = theme.text;
      prompt = theme.mauve;
      "hl+" = theme.red;
      "selected-bg" = theme.surface1;
      border = theme.overlay0;
      label = theme.text;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Macchiato";
      pager = "less -FR";
    };
    themes."Catppuccin Macchiato" = {
      src = catppuccin-bat;
      file = "themes/Catppuccin Macchiato.tmTheme";
    };
  };

  programs.lazygit = {
    enable = true;
    package = null;
    enableZshIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        python = "3.12";
      };
    };
  };
}
