{
  description = "Cross-platform home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = { system, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit homeDirectory; };
        };
    in {
      homeConfigurations = {
        # Personal Mac
        mads = mkHome {
          system = "aarch64-darwin";
          homeDirectory = "/Users/mads";
        };

        # Linux devcontainer (vscode user)
        vscode = mkHome {
          system = "aarch64-linux";
          homeDirectory = "/home/vscode";
        };
      };
    };
}
