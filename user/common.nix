{ config, lib, pkgs, ... }: {
    home = {
        username = "kevin";
        homeDirectory = "/home/kevin";

        packages = with pkgs; [
            anki
            celluloid
            discord
            exiftool
            gnome.seahorse
            hunspellDicts.en_US

            # https://github.com/NixOS/nixpkgs/issues/153436
            # libreoffice-fresh
            libreoffice

            lutris
            multimc
            neofetch
            nixos-option
            protontricks

            (python3.withPackages (
                python-packages: with python-packages; [
                    mypy
                    pylint
                ]
            ))

            qbittorrent
            spotify
            xournalpp
            zoom-us
        ];

        stateVersion = "21.05";
    };

    nixpkgs.config.allowUnfree = true;

    programs = {
        home-manager.enable = true;  # Let Home Manager install and manage itself

        firefox = {
            enable = true;

            package = pkgs.firefox.override {
                cfg.enablePlasmaBrowserIntegration = true;
            };
        };

        git = {
            enable = true;
            userName = "Kevin Cruse";
            userEmail = "kevincruse7@gmail.com";

            extraConfig = {
                credential.helper = "store";
                init.defaultBranch = "main";
            };
        };

        texlive.enable = true;
        vscode.enable = true;
    };
}
