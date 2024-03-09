{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      inherit system;
      modules = [
        # https://nixos.wiki/wiki/Flakes#Importing_packages_from_multiple_channels
        ({
          config,
          pkgs,
          ...
        }: {nixpkgs.overlays = [overlay-unstable];})
        ./configuration.nix
        nixos-wsl.nixosModules.wsl
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
