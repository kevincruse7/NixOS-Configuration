{ config, lib, pkgs, ... }: {
    imports = [ ./common.nix ];

    home = {
        username = "kevin";
        homeDirectory = "/home/kevin";

        packages = with pkgs; [(python3.withPackages (
            python-packages: with python-packages; [
                mypy
                pylint
            ]
        ))];

        stateVersion = "22.05";
    };

    programs = {
        git = {
            enable = true;

            extraConfig = {
                credential.helper = "store";
                init.defaultBranch = "main";
                pull.rebase = true;
            };

            userName = "Kevin Cruse";
            userEmail = "kevincruse7@gmail.com";
        };

        home-manager.enable = true;
    };
}
