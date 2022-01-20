{ config, lib, pkgs, ... }: {
    imports = [
        <home-manager/nixos>

        <nixos-hardware/common/cpu/intel>
        <nixos-hardware/common/pc>
        <nixos-hardware/common/pc/ssd>

        ../modules/minecraftd
    ];

    boot = {
        consoleLogLevel = 3;
        kernelModules = [ "kvm-intel" ];

        kernelParams = [
            "nvidia-drm.modeset=1"
            "quiet"
        ];

        initrd.availableKernelModules = [
            "ahci"
            "sd_mod"
            "sr_mod"
            "usb_storage"
            "usbhid"
            "xhci_pci"
        ];

        loader = {
            # Enable only on first build to avoid NVRAM wear
            efi.canTouchEfiVariables = false;

            systemd-boot = {
                enable = true;
                configurationLimit = 10;
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

    home-manager.users.kevin = import ../user/desktop.nix;

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

    hardware = {
        enableRedistributableFirmware = true;

        pulseaudio = {
            enable = true;

            # DAC configuration
            daemon.config = {
                avoid-resampling = true;
                default-sample-format = "s24le";
                default-sample-rate = 96000;
                resample-method = "soxr-vhq";
            };
        };
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };

    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
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

    powerManagement.cpuFreqGovernor = "performance";

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
        minecraftd.enable = false;
        mullvad-vpn.enable = true;
        printing.enable = true;
        sshd.enable = true;

        xserver = {
            enable = true;

            desktopManager.plasma5 = {
                enable = true;
                phononBackend = "vlc";
            };

            displayManager = {
                sddm.enable = true;

                setupCommands = ''
                    # Force composition pipeline on to fix KDE lagginess
                    ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign \
                        CurrentMetaMode="nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"

                    # Turn screen off after 30 seconds of inactivity
                    ${pkgs.enable-dpms}/bin/enable-dpms
                '';
            };

            videoDrivers = [ "nvidia" ];
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
