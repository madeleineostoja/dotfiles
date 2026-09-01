{
  config,
  pkgs,
  homeDirectory,
  agents,
  ...
}:

let
  dotfiles = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = baseNameOf homeDirectory;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.11";

  programs.home-manager.enable = true;

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-30 days";
    frequency = "weekly";
    store.cleanup = true;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  # Modules
  imports = [
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/ssh.nix
  ];

  # Packages
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    dust

    # Git
    gh

    # Dev
    nixfmt
    fresh-editor
    mas
    supabase-cli
  ];

  # Config files
  home.file = {
    ".hammerspoon/init.lua".source = mkLink "configs/hammerspoon.lua";
    ".config/worktrunk/config.toml".source = mkLink "configs/worktrunk.toml";
    ".config/otty".source = mkLink "configs/otty";
    ".config/fresh".source = mkLink "configs/fresh";

    # Pi
    ".pi/agent" = {
      source = "${agents}";
      recursive = true;
    };
    ".pi/agent/settings.json".source = mkLink "configs/pi/settings.json";
    ".pi/agent/keybindings.json".source = mkLink "configs/pi/keybindings.json";
    ".pi/agent/pipkin/config.json".source = mkLink "configs/pi/pipkin.json";

    # Zed
    ".config/zed/settings.json".source = mkLink "configs/zed/settings.json";
    ".config/zed/keymap.json".source = mkLink "configs/zed/keymap.json";
  };
}
