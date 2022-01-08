{ config, lib, pkgs, ... }: {
    boot = {
        consoleLogLevel = 3;
        kernelParams = [ "quiet" ];

        loader = {
            # Enable only on first build to avoid NVRAM wear
            efi.canTouchEfiVariables = false;

            systemd-boot = {
                configurationLimit = 10;
                enable = true;
            };
        };
    };

    environment.systemPackages = with pkgs; [
        anki
        celluloid
        disable-dpms
        discord
        element-desktop
        enable-dpms
        exiftool
        firefox
        gnome.dconf-editor
        gnome.seahorse
        hunspellDicts.en_US
        libreoffice-fresh
        libsForQt5.ark
        libsForQt5.kcalc
        libsForQt5.ksystemlog
        lutris
        mullvad-vpn
        multimc
        neofetch
        nixos-option
        partition-manager
        protontricks

        (python3.withPackages (
            python-packages: with python-packages; [
                mypy
                pylint
            ]
        ))

        qbittorrent
        spotify
        texlive.combined.scheme-basic
        vscode
        xournalpp
        zoom-us
    ];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
        };

        "/boot" = {
            device = "/dev/disk/by-label/efi";
            fsType = "vfat";
        };
    };

    fonts = {
        fontconfig.defaultFonts = {
            monospace = [ "Noto Sans Mono" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
        };

        fonts = with pkgs; [
            noto-fonts
            noto-fonts-cjk
        ];
    };

    hardware.pulseaudio = {
        enable = true;

        # DAC configuration
        daemon.config = {
            avoid-resampling = true;
            default-sample-format = "s24le";
            default-sample-rate = 96000;
            resample-method = "soxr-vhq";
        };
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };

    networking = {
        networkmanager.enable = true;
        useDHCP = false;
    };

    nix = {
        package = pkgs.nixUnstable;
        extraOptions = "experimental-features = nix-command flakes";
    };

    nixpkgs = {
        config = {
            allowUnfree = true;
            firefox.enablePlasmaBrowserIntegration = true;
        };

        overlays = [(self: super: {
            disable-dpms = self.callPackage ../pkgs/disable-dpms {};
            enable-dpms = self.callPackage ../pkgs/enable-dpms {};
        })];
    };

    programs = {
        git = {
            enable = true;

            config = {
                credential.helper = "store";
                init.defaultBranch = "main";
                pull.rebase = true;

                user = {
                    email = "kevincruse7@gmail.com";
                    name = "Kevin Cruse";
                };
            };
        };

        java = {
            enable = true;
            package = pkgs.jdk;
        };

        nano.nanorc = ''
            set autoindent
            set linenumbers
            set mouse
            set smarthome
            set tabsize 4
            set tabstospaces
            set trimblanks
        '';

        steam.enable = true;
    };

    security = {
        # Allows users in "wheel" group to change network settings without password prompt
        polkit.extraConfig = ''
            polkit.addRule(function(action, subject) {
                if (
                    action.id == "org.freedesktop.NetworkManager.settings.modify.system"
                    && subject.isInGroup("wheel")
                ) {
                    return polkit.Result.YES;
                }
            });
        '';

        # Allow users in "wheel" group to use sudo without a password
        sudo.extraRules = [{
            groups = [ "wheel" ];

            commands = [{
                command = "ALL";
                options = [ "NOPASSWD" ];
            }];
        }];
    };

    services = {
        gnome.gnome-keyring.enable = true;  # Required by some apps for storing passwords
        mullvad-vpn.enable = true;
        printing.enable = true;

        xserver = {
            displayManager.sddm.enable = true;
            enable = true;

            desktopManager.plasma5 = {
                enable = true;
                phononBackend = "vlc";
            };
        };
    };

    swapDevices = [{ device = "/swapfile"; }];
    system.stateVersion = "21.05";

    users = {
        mutableUsers = false;

        users.kevin = {
            description = "Kevin Cruse";
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            passwordFile = "/etc/nixos/password.txt";
        };
    };
}
