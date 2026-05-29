{
  description = "MacBook configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agents = {
      url = "github:madeleineostoja/agents";
      flake = false;
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-godot = {
      url = "github:catppuccin/godot";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agents,
      catppuccin,
      catppuccin-godot,
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
        modules = [
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
        extraSpecialArgs = {
          inherit
            homeDirectory
            agents
            catppuccin-godot
            ;
        };
      };
    };
}
