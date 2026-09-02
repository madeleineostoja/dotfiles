{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    hunk
    worktrunk
  ];

  xdg.configFile."hunk/config.toml".text = ''
    theme = "catppuccin-macchiato"
    mode = "split"
    agent_notes = true
  '';

  programs.zsh.initContent = lib.mkBefore ''
    eval "$(${lib.getExe pkgs.worktrunk} config shell init zsh)"
  '';

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon?"
      "._*"
      "*.swp"
      "*.swo"
      "*~"
      ".pi/implement"
    ];
    settings = {
      user = {
        name = "Madi Ostoja";
        email = "madi@madeleineostoja.com";
      };

      init.defaultBranch = "main";

      core = {
        pager = "delta";
        editor = "fresh";
      };

      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      fetch.prune = true;
      rerere.enabled = true;
    };
    iniContent.pager = {
      diff = lib.mkForce "hunk pager";
      show = lib.mkForce "hunk pager";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };
}
