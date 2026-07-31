{
  description = "MacBook configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    worktrunk = {
      url = "github:max-sixty/worktrunk";
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
      hunk,
      worktrunk,
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
          hunk.homeManagerModules.default
          worktrunk.homeModules.default
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
