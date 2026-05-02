{
  description = "Nix-based macOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nix-darwin, home-manager, ... }:
    let
      username = "gam0296";
      hostname = "GaM0296";
      configurationName = "mac";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.${configurationName} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs username hostname configurationName;
        };
        modules = [
          ./hosts/mac/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit username configurationName;
            };
            home-manager.users.${username} = import ./home/default.nix;
          }
        ];
      };
    };
}
