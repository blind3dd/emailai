# This file allows direnv to use the flake environment
# It delegates to the flake's devShell

(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    flake-compat = fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-utils.locked.rev}.tar.gz";
      sha256 = lock.nodes.flake-utils.locked.narHash;
    };
  in
  import flake-compat { src = ./.; }
).shellNix
