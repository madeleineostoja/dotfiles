{
  description = "Mads Macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      agents,
      ...
    }:
    let
      system = "aarch64-darwin";
      user = "mads";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      apps.${system}.home-manager = {
        type = "app";
        program = "${home-manager.packages.${system}.default}/bin/home-manager";
      };

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
        extraSpecialArgs = {
          inherit user agents;
        };
      };
    };
}
