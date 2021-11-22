{pkgs, ...}:

with pkgs;
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

        file = let
            no-display-desktop = callPackage ../pkgs/no-display-desktop {};
        in {
            ".local/share/applications/cups.desktop".source = no-display-desktop;
            ".local/share/applications/multimc.desktop".source = no-display-desktop;
            ".local/share/applications/nvidia-settings.desktop".source = no-display-desktop;
            ".local/share/applications/Proton Experimental.desktop".source = no-display-desktop;
            ".local/share/applications/protontricks.desktop".source = no-display-desktop;
            ".local/share/applications/xterm.desktop".source = no-display-desktop;
        };

        packages = [
            anki
            discord
            exiftool
            firefox
            hunspellDicts.en_US
            libreoffice-fresh
            multimc
            neofetch
            nixos-option
            protontricks
            qbittorrent
            spotify
            texlive.combined.scheme-full
            vlc
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
            extraConfig.init.defaultBranch = "main";
        };
    };
}
