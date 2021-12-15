# System module installs and configures a Minecraft
# server to automatically run under its own user

{ config, lib, pkgs, ... }: let
    minecraft-server = pkgs.callPackage ../../pkgs/minecraft-server {};
in {
    environment.systemPackages = [ minecraft-server ];

    networking.firewall = {
        allowedTCPPorts = [ 25565 ];
        allowedUDPPorts = [ 25565 ];
    };

    systemd = {
        services.minecraftd = {
            description = "Minecraft server daemon";
            enable = true;
            wantedBy = [ "multi-user.target" ];

            after = [
                "local-fs.target"
                "network.target"
                "multi-user.target"
            ];

            serviceConfig = {
                Group = "minecraft";
                ExecStart = "${minecraft-server}/bin/minecraftd start";
                ExecStop = "${minecraft-server}/bin/minecraftd stop";
                Type = "forking";
                User = "minecraft";
            };
        };
    };

    users = {
        groups.minecraft = {};

        users.minecraft = {
            createHome = true;
            description = "Minecraft server user";
            group = "minecraft";
            home = "/srv/minecraft";
            isSystemUser = true;
            shell = pkgs.bash;
        };
    };
}
