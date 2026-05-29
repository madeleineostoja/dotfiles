{
  description = "MacBook configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agents = {
      url = "github:madeleineostoja/agents";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-delta = {
      url = "github:catppuccin/delta";
      flake = false;
    };
    catppuccin-eza = {
      url = "github:catppuccin/eza";
      flake = false;
    };
    catppuccin-godot = {
      url = "github:catppuccin/godot";
      flake = false;
    };
    catppuccin-lazygit = {
      url = "github:catppuccin/lazygit";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agents,
      catppuccin-bat,
      catppuccin-delta,
      catppuccin-eza,
      catppuccin-godot,
      catppuccin-lazygit,
      ...
    }:
    let
      system = "aarch64-darwin";
      homeDirectory = "/Users/mads";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.mads = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit
            homeDirectory
            agents
            catppuccin-bat
            catppuccin-delta
            catppuccin-eza
            catppuccin-godot
            catppuccin-lazygit
            ;
        };
      };
    };
}
