{ config, lib, pkgs, ... }: {
    imports = [ ./common.nix ];

    home = {
        username = "kevin";
        homeDirectory = "/home/kevin";

        packages = with pkgs; [
            fontconfig
            gdb
            ghc
            gnumake
            gnupatch

            (perl.withPackages (
                perl-packages: with perl-packages; [
                    Expect
                ]
            ))

            (python3.withPackages (
                python-packages: with python-packages; [
                    graphviz
                    jupyter
                    matplotlib
                    mypy
                    numexpr
                    numpy
                    scikit-learn
                    scipy
                    seaborn
                    pandas
                    pylint
                ]
            ))

            qemu
            racket
            strace
            valgrind
        ];

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
        man.enable = false;  # Use system install of man-db
    };
}
