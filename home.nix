{
  config,
  pkgs,
  lib,
  homeDirectory,
  agents,
  catppuccin-godot,
  ...
}:

let
  dotfiles = "${homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
  pnpmHome = "${homeDirectory}/Library/pnpm";

  # Global pnpm packages, if a nix package isn't available or updated enough
  pnpmGlobals = [
    "sentry"
    "@earendil-works/pi-coding-agent"
    "@schpet/linear-cli"
  ];
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
    mise
    pnpm
    nixfmt
    supabase-cli
    fresh-editor
  ];

  # Environment
  home.sessionVariables = {
    PNPM_HOME = pnpmHome;
    PNPM_CONFIG_STORE_DIR = "${pnpmHome}/store";
  };

  # Fix PNPM global installs
  home.sessionPath = [
    pnpmHome
    "${pnpmHome}/bin"
  ];

  # Ensure global pnpm packages are installed
  home.activation.pnpmGlobals = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PNPM_HOME="${pnpmHome}"
    export PATH="${pkgs.nodejs}/bin:${pkgs.pnpm}/bin:$PNPM_HOME/bin:$PATH"
    for pkg in ${lib.escapeShellArgs pnpmGlobals}; do
      if ! ${pkgs.pnpm}/bin/pnpm ls -g --depth=0 2>/dev/null | grep -q "$pkg"; then
        run ${pkgs.pnpm}/bin/pnpm add -g --ignore-scripts "$pkg"
      fi
    done
  '';

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
