{
  config,
  pkgs,
  lib,
  homeDirectory,
  agents,
  ...
}:

let
  dotfiles = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
  pnpmHome = "${homeDirectory}/Library/pnpm";
in
{
  home.username = baseNameOf homeDirectory;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Modules
  imports = [
    ./modules/zsh.nix
  ];

  # Packages
  home.packages = with pkgs; [
    # Shell
    starship

    # CLI tools
    bat
    eza
    ripgrep
    fd
    fzf
    dust

    # Git
    git
    delta
    gh
    worktrunk

    # Dev
    mise
    pnpm
    nixfmt

    # Other
    claude-code
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
    PNPM_HOME = pnpmHome;
  };

  # Fix PNPM global installs
  home.sessionPath = [ pnpmHome ];

  # Config files
  home.file = {
    ".config/git/config".source = mkLink "configs/git/config";
    ".config/git/ignore".source = mkLink "configs/git/ignore";
    ".ssh/config".source = mkLink "configs/ssh";
    ".config/ghostty/config".source = mkLink "configs/ghostty";
    ".hammerspoon/init.lua".source = mkLink "configs/hammerspoon.lua";

    # Pi
    ".pi/agent/settings.json".source = mkLink "configs/pi/settings.json";
    ".pi/agent/models.json".source = mkLink "configs/pi/models.json";
    ".pi/agent/keybindings.json".source = mkLink "configs/pi/keybindings.json";
    ".pi/agent/AGENTS.md".source = "${agents}/AGENTS.md";
    ".pi/agent/skills" = {
      source = "${agents}/skills";
      recursive = true;
    };

    # Claude
    ".claude/settings.json".source = mkLink "configs/claude/settings.json";
    ".claude/statusline-command.sh".source = mkLink "configs/claude/statusline-command.sh";
    ".claude/CLAUDE.md".source = "${agents}/AGENTS.md";
    ".claude/skills" = {
      source = "${agents}/skills";
      recursive = true;
    };
  };
}
