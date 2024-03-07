# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/nix-scripts.nix
    inputs.home-manager.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos"; # This can't easily be changed while using wsl. https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/4

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "nixos" = import ./home.nix;
    };
  };

  programs.zsh.enable = true;
  users.users.nixos.shell = pkgs.zsh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    wget
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackages programs
    # here, NOT in environment.systemPackages
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
