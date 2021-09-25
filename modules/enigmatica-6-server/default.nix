# System module that installs and configures an Enigmatica 6 server to automatically run under its own user

{config, pkgs, ...}:

with pkgs;
let
    enigmatica-6-server = callPackage ../../pkgs/enigmatica-6-server {};
in {
    environment.systemPackages = [ enigmatica-6-server ];


    networking.firewall = {
        allowedTCPPorts = [ 25565 ];
        allowedUDPPorts = [ 25565 ];
    };


    systemd = {
        services.minecraftd = {
            enable = true;
            description = "Enigmatica 6 server";
            wantedBy = [ "multi-user.target" ];
            
            after = [
                "local-fs.target"
                "network.target"
                "multi-user.target"
            ];

            serviceConfig = {
                Type = "forking";
                ExecStart = "${enigmatica-6-server}/bin/minecraftd start";
                ExecStop = "${enigmatica-6-server}/bin/minecraftd stop";
                User = "minecraft";
                Group = "minecraft";
            };
        };

        tmpfiles.rules = [(
            "L+ ${config.users.users.minecraft.home}/server-setup-config.yaml"
            + " - - - - ${enigmatica-6-server}/etc/server-setup-config.yaml"
        )];
    };


    users = {
        groups.minecraft = {};

        users.minecraft = {
            isSystemUser = true;
            description = "Enigmatica 6 server";
            group = "minecraft";
            home = "/srv/minecraft";
            createHome = true;
            shell = bash;
        };
    };
}
