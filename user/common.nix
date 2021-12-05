{config, lib, pkgs, ...}:

{
    home = {
        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "21.05";

        username = "kevin";
        homeDirectory = "/home/kevin";

        packages = with pkgs; [
            anki
            celluloid
            discord
            exiftool
            firefox
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
            texlive.combined.scheme-full
            vscode
            xournalpp
            zoom-us
        ];
    };


    nixpkgs.config = {
        allowUnfree = true;
        firefox.enablePlasmaBrowserIntegration = true;
    };


    programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;

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
