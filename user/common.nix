{ config, lib, pkgs, ... }: {
    home = {
        homeDirectory = "/home/kevin";
        username = "kevin";

        packages = with pkgs; [
            anki
            celluloid
            discord
            exiftool
            gnome.seahorse
            hunspellDicts.en_US
            libreoffice-fresh
            libsForQt5.kio-gdrive
            multimc
            neofetch
            nixos-option
            protontricks
            qbittorrent
            spotify
            xournalpp
            zoom-us

            (
                python3.withPackages (
                    python-packages: with python-packages; [
                        mypy
                        pylint
                    ]
                )
            )
        ];

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "21.05";
    };


    nixpkgs.config = {
        allowUnfree = true;
        firefox.enablePlasmaBrowserIntegration = true;
    };


    programs = {
        firefox.enable = true;
        home-manager.enable = true;  # Let Home Manager install and manage itself
        texlive.enable = true;
        vscode.enable = true;

        git = {
            enable = true;
            userName = "Kevin Cruse";
            userEmail = "kevincruse7@gmail.com";

            extraConfig = {
                credential.helper = "store";
                init.defaultBranch = "main";
            };
        };
    };
}
