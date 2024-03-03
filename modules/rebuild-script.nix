{ pkgs, ... }: 
let script = pkgs.writeShellScriptBin "rebuild" ''
      echo "rebuilding!"
    '';
in {
  environment.systemPackages = [ script ];
}
