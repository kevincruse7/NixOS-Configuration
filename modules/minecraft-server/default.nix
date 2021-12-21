# System module installs and configures a Minecraft
# server to automatically run under its own user

{ config, lib, pkgs, ... }: let
    minecraft-server = pkgs.callPackage ../../pkgs/minecraft-server {};
in {
    environment.systemPackages = [ minecraft-server ];

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
        bind = "127.0.0.1";  # Only allow connections from localhost

        # MySQL settings required by LogBlock
        settings.mysqld = {
            default_storage_engine = "INNODB";
            innodb_buffer_pool_size = "256M";
            key_buffer_size = "128M";
            max_connections = 100;
            query_cache_size = 0;
            skip_name_resolve = true;
        };

        initialDatabases = [{
            name = "logblock";
            schema = ./logblock-db-schema.sql;
        }];

        initialScript = pkgs.writeText "logblock-db-users.sql" ''
            CREATE USER minecraft@127.0.0.1;
            GRANT ALL PRIVILEGES ON logblock.* TO minecraft@127.0.0.1;
        '';
    };

    systemd.services.minecraftd = {
        enable = false;
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
            ExecStart = "${minecraft-server}/bin/minecraftd start";
            ExecStop = "${minecraft-server}/bin/minecraftd stop";
        };
    };

    users = {
        groups.minecraft = {};

        users.minecraft = {
            isSystemUser = true;
            description = "Minecraft server user";
            group = "minecraft";
            home = "/srv/minecraft";
            createHome = true;
            shell = pkgs.bash;
        };
    };
}
