{pkgs, ...}: let
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    # cd to your config dir
    pushd ~/.nix-config/

    # Autoformat your nix files
    alejandra . -q

    # Shows your changes
    git diff -U0 -- '*.nix'

    # Stage all changes so they are included in rebuild
    git add .

    ## Spinner stuff start ##
    spinner_pid=
    function start_spinner {
        set +m
        echo -n "$1  "
        { while true; do for X in '—' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done & } 2>/dev/null
        spinner_pid=$!
    }

    function stop_spinner {
        { kill -9 $spinner_pid && wait; } 2>/dev/null
        set -m
        echo -en "\033[2K\r"
    }

    trap stop_spinner EXIT
    ## Spinner stuff end ##

    start_spinner "🛠️ NixOS Rebuilding"

    # Rebuild, output simplified errors, log tracebacks
    sudo nixos-rebuild switch --flake .#default &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

    stop_spinner

    # Commit all changes prompting for message
    if ! git commit -a; then
        echo "⚠️ Cancelling commit. Changes built but aren't commited!..."
        popd
        exit 1
    fi

    # Push to remote
    git push

    # Back to where you were
    popd

    # Notify all OK!
    echo "✅ NixOS Rebuilt"
  '';

  editConfig = pkgs.writeShellScriptBin "edit-sys-config" ''
    code ~/.config/configuration.nix
  '';
in {
  environment.systemPackages = [rebuild editConfig];
}
