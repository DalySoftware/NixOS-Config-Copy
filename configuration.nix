# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./modules/rebuild-script.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    wget
    git-crypt
    gnupg
    bat
    alejandra
    delta
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackages programs
    # here, NOT in environment.systemPackages
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.shellInit = ''
    echo 'creating .bash_env_noninteractive'
    echo 'export PATH=$PATH:/run/current-system/sw/bin' > ~/.bash_env_noninteractive
  '';

  environment.interactiveShellInit = ''
    export EDITOR=code
    export VISUAL=code
  '';

  programs.git.enable = true;
  programs.git.config = {
    core = {
      editor = "code --wait";
      pager = "delta";
    };
    init = {
      defaultBranch = "main";
    };
    rebase = {
      autosquash = true;
      autostash = true;
    };
    push = {
      autoSetupRemote = true;
    };
    format = {
      pretty = "oneline";
    };
    branch = {
      sort = "-committerdate";
    };
    rerere = {
      enabled = true;
    };
    alias = {
      br = "! git for-each-ref --color --sort=-committerdate --format='%(color:blue)%(color:red)%(ahead-behind:main)%(color:blue);%(color:default)%(refname:short);%(color:yellow)%(committerdate:relative);%(color:blue)%(committername);%(color:default)%(subject)' refs/heads/ | column --separator=';' --table";
    };
  };
}
