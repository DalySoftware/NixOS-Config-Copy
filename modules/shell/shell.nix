{pkgs, ...}: let
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

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.unstable.atuin;
    settings = {
      style = "compact";
      enter_accept = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    nerdfonts
  ];
}
