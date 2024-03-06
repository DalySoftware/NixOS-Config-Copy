{pkgs, ...}: {
  programs.git.enable = true;
  programs.git.extraConfig = {
    core = {
      editor = "code --wait";
      pager = "delta";
    };
    delta = {
      side-by-side = true;
      hunk-header-style = "omit";
      zero-style = "dim";
      hyperlinks = true;
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
