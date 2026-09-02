{
  config,
  pkgs,
  user,
  agents,
  ...
}:

let
  homeDirectory = "/Users/${user}";
  dotfiles = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
  sysCommand = pkgs.writeShellApplication {
    name = "sys";
    runtimeInputs = [ pkgs.gum ];
    text = ''
      exec "$HOME/dotfiles/bin/sys" "$@"
    '';
  };
in
{
  home.username = user;
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
    ./modules/editor.nix
    ./modules/git.nix
    ./modules/mise.nix
    ./modules/shell.nix
    ./modules/ssh.nix
  ];

  # Packages
  home.packages = with pkgs; [
    mas
    ripgrep
    fd
    dust
    gh
    sysCommand
    supabase-cli # TODO: Remove
  ];

  # Config files
  home.file = {
    ".config/otty".source = mkLink "configs/otty";
    ".hammerspoon/init.lua".source = mkLink "configs/hammerspoon.lua";
    ".config/zed/settings.json".source = mkLink "configs/zed/settings.json";
    ".config/zed/keymap.json".source = mkLink "configs/zed/keymap.json";

    # Pi
    ".pi/agent/settings.json".source = mkLink "configs/pi/settings.json";
    ".pi/agent/keybindings.json".source = mkLink "configs/pi/keybindings.json";
    ".pi/agent/pipkin/config.json".source = mkLink "configs/pi/pipkin.json";
    ".pi/agent" = {
      source = "${agents}";
      recursive = true;
    };
  };
}
