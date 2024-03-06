{
  pkgs,
  lib,
  ...
}: let
  ompTheme = ./pure_custom.omp.json;
in {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ompTheme);
  };

  programs.hstr.enable = true;
  programs.hstr.enableZshIntegration = lib.mkAfter true;
  programs.zsh.initExtra = lib.mkAfter ''
    export HSTR_CONFIG="prompt-bottom,raw-history-view,hicolor";
  '';

  home.packages = with pkgs; [
    nerdfonts
  ];
}
