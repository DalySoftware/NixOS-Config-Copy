{pkgs, ...}: let
  ompTheme = ./pure_custom.omp.json;
in {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      export HSTR_CONFIG="prompt-bottom,raw-history-view,hicolor";
      bindkey -s "$terminfo[kcuu1]" "\C-a hstr -- \C-j";
    '';
    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.hstr.enable = true;
  programs.hstr.enableZshIntegration = true;

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ompTheme);
  };

  home.packages = with pkgs; [
    nerdfonts
  ];
}
