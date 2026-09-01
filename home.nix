{
  config,
  pkgs,
  homeDirectory,
  agents,
  catppuccin-godot,
  ...
}:

let
  dotfiles = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = baseNameOf homeDirectory;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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
  ];

  # Packages
  home.packages = with pkgs; [
    # Shell
    starship

    # CLI tools
    bat
    ripgrep
    fd
    fzf
    dust

    # Git
    lazygit

    # Dev
    nixfmt
    # Keep until its remaining workflow is owned by the relevant repository.
    supabase-cli
    fresh-editor
  ];

  # Config files
  home.file = {
    ".ssh/config".source = mkLink "configs/ssh";
    ".hammerspoon/init.lua".source = mkLink "configs/hammerspoon.lua";
    ".config/worktrunk/config.toml".source = mkLink "configs/worktrunk.toml";
    ".config/otty".source = mkLink "configs/otty";
    ".config/fresh".source = mkLink "configs/fresh";

    # cmux
    "Library/Application Support/com.cmuxterm.app/config.ghostty".source =
      mkLink "configs/cmux/config.ghostty";
    ".config/cmux/cmux.json".source = mkLink "configs/cmux/cmux.json";

    # Godot
    "Library/Application Support/Godot/editor_settings-4.6.tres".source =
      mkLink "configs/godot/settings.tres";
    "Library/Application Support/Godot/text_editor_themes/Catppuccin-Macchiato.tet".source =
      "${catppuccin-godot}/themes/Catppuccin Macchiato.tet";

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
