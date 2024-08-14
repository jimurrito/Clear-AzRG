# nix-shell config for an AzCLI development environment.
#
# What does this do?
# > Installs Python 3.9
# > creates a python venv named 'env' (if not already created)
# > connects to the virtual env
# > Updates pip 
# > Installs the Azdev from pip (if not already done)
#
# How to use?
# > cd to this dir
# > run: `nix-shell`
#

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [ powershell vscode-extensions.ms-vscode.powershell ];

  shellHook = ''
  pwsh && exit
  '';
}

