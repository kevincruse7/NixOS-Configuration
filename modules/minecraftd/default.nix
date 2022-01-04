# System module installs and configures a Minecraft
# server to automatically run under its own user

{ config, lib, pkgs, ... }: with lib; let
    minecraftd = pkgs.callPackage ../../pkgs/minecraftd {};
in {
    options.services.minecraftd.enable = mkEnableOption "minecraftd";

    config = mkIf config.services.minecraftd.enable {
        environment.systemPackages = [ minecraftd ];

        # Allow traffic for Dynmap and Minecraft servers
        networking.firewall = {
            allowedTCPPorts = [
                8123
                25565
            ];

            allowedUDPPorts = [
                8123
                25565
            ];
        };

        # MySQL database for LogBlock plugin
        services.mysql = {
            enable = true;
            package = pkgs.mariadb;
            initialDatabases = [{ name = "logblock"; }];

            # MySQL settings required by LogBlock
            settings.mysqld = {
                bind_address = "127.0.0.1";  # Only allow connections from localhost
                default_storage_engine = "INNODB";
                innodb_buffer_pool_size = "256M";
                key_buffer_size = "128M";
                max_connections = 100;
                query_cache_size = 0;
                skip_name_resolve = true;
            };

            initialScript = pkgs.writeText "logblock-db-user.sql" ''
                CREATE USER minecraft@127.0.0.1;
                GRANT ALL PRIVILEGES ON logblock.* TO minecraft@127.0.0.1;
            '';
        };

        systemd.services.minecraftd = {
            enable = true;
            description = "Minecraft server daemon";
            wantedBy = [ "multi-user.target" ];

            after = [
                "local-fs.target"
                "network.target"
                "multi-user.target"
            ];

            serviceConfig = {
                Type = "forking";
                User = "minecraft";
                Group = "minecraft";
                ExecStart = "${minecraftd}/bin/minecraftd start";
                ExecStop = "${minecraftd}/bin/minecraftd stop";
            };
        };

        users = {
            groups.minecraft = {};

            users.minecraft = {
                description = "Minecraft server user";
                isSystemUser = true;
                group = "minecraft";
                home = "/srv/minecraft";
                createHome = true;
                shell = pkgs.bash;
            };
        };
    };
}
