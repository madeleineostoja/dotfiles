{ config, pkgs, username, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.username = username;
  home.homeDirectory = "/Users/${username}";
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
    atuin
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
    skhd
  ];

  # Environment
  home.sessionVariables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
    LANG = "en_NZ.UTF-8";
    LC_ALL = "en_NZ.UTF-8";
  };

  # Config files
  home.file = {
    ".config/git/config".source = mkLink "configs/git/config";
    ".config/git/ignore".source = mkLink "configs/git/ignore";
    ".config/ghostty/config".source = mkLink "configs/ghostty";
    ".config/skhd/skhdrc".source = mkLink "config/skhdrc";
    
    # Claude
    ".claude/CLAUDE.md".source = mkLink "configs/claude/CLAUDE.md";
    ".claude/settings.json".source = mkLink "configs/claude/settings.json";
    ".claude/statusline-command.sh".source = mkLink "configs/claude/statusline-command.sh";
    ".claude/skills" = {
      source = mkLink "configs/claude/skills";
      recursive = true;
    };
  };

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
}