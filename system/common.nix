# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{pkgs, ...}:

with pkgs;
{
    imports = [ /etc/nixos/hardware-configuration.nix ];


    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "21.05";  # Did you read the comment?


    nixpkgs.config.allowUnfree = true;


    boot = {
        consoleLogLevel = 3;
        kernelParams = [ "quiet" ];

        loader = {
            # Enable only when necessary to avoid NVRAM wear
            #efi.canTouchEfiVariables = true;

            systemd-boot = {
                enable = true;
                configurationLimit = 10;
            };
        };
    };


    environment = {
        systemPackages = [
            gnome.dconf-editor
            gnome.gnome-tweak-tool
            gnomeExtensions.appindicator
            mullvad-vpn
        ];

        gnome.excludePackages = [
            epiphany
            gnome.geary
            gnome.totem
        ];
    };


    fonts = {
        fonts = [
            noto-fonts
            noto-fonts-cjk
        ];

        fontconfig.defaultFonts = {
            monospace = [ "Noto Sans Mono" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
        };
    };


    # Audio DAC configuration
    hardware.pulseaudio.daemon.config = {
        default-sample-format = "s24le";
        default-sample-rate = 96000;
        resample-method = "soxr-vhq";
        avoid-resampling = true;
    };


    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;


    programs = {
        java = {
            enable = true;
            package = jdk;
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
        mullvad-vpn.enable = true;

        xserver = {
            enable = true;
            desktopManager.gnome.enable = true;

            displayManager.gdm = {
                autoSuspend = false;
                enable = true;
            };
        };
    };


    swapDevices = [{
        device = "/swapfile";
    }];


    users = {
        mutableUsers = false;

        users.kevin = {
            isNormalUser = true;
            description = "Kevin Cruse";
            extraGroups = [ "wheel" ];
            passwordFile = "${./password.txt}";
        };
    };
}
