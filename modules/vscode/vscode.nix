{
  pkgs,
  lib,
  ...
}: {
  home.file.".vscode-server/server-env-setup".source = ./server-env-setup;

  home.packages = with pkgs; [
    nil
  ];

  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #     jnoortheen.nix-ide
  #   ];
  #   userSettings = {
  #     "nix.enableLanguageServer" = true;
  #     "nix.serverPath" = "nil";
  #   };
  # };

  # nixpkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "vscode"
  #   ];
}
