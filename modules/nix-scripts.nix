{pkgs, ...}: let
  script = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    # cd to your config dir
    pushd ~/.nix-config/

    # Autoformat your nix files
    alejandra . -q

    # Shows your changes
    git diff -U0 -- '*.nix'

    # Stage all changes so they are included in rebuild
    git add .

    echo "🛠️ NixOS Rebuilding..."

    # Rebuild, output simplified errors, log tracebacks
    sudo nixos-rebuild switch --flake .#default &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

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
in {
  environment.systemPackages = [script];
}
