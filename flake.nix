{
  description = "Kept webapp experience";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

      in
      {
        devShell = with pkgs; mkShell {
          packages = [
            nodejs-18_x
            postgresql_15
          ];

          shellHook = ''
            export PGDIR=$(pwd)/.direnv/.postgres
            export PGHOST=$PGDIR
            export PGDATA=$PGDIR/data
            export PGLOG=$PGDIR/log

            if test ! -d $PGDIR; then
              mkdir -p $PGDIR
            fi

            if [ ! -d $PGDATA ]; then
              echo 'Initializing postgresql database...'
              initdb $PGDATA --auth=trust >/dev/null

              cat <<EOF >>"$PGDATA/postgresql.conf"
            listen_addresses = 'localhost'
            unix_socket_directories = '$PGHOST'
            EOF

              echo "CREATE USER admin WITH PASSWORD 'password' SUPERUSER" | postgres --single -E postgres
              echo "CREATE DATABASE webapp_db OWNER admin" | postgres --single -E postgres
            fi
          '';
        };
      });
}

