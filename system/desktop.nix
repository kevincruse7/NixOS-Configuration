{ config, lib, pkgs, ... }: {
    imports = [
        ./common.nix
        ../modules/minecraftd
    ];

    boot = {
        kernelParams = [ "nvidia-drm.modeset=1" ];

        initrd.availableKernelModules = [
            "sd_mod"
            "sr_mod"
            "usb_storage"
        ];
    };

    home-manager.users.kevin = import ../user/desktop.nix;

    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
    };

    powerManagement.cpuFreqGovernor = "performance";

    services = {
        minecraftd.enable = false;
        sshd.enable = true;

        xserver = {
            displayManager.setupCommands = ''
                # Force composition pipeline on to fix KDE lagginess
                ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign \
                    CurrentMetaMode="nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"

                # Turn screen off after 30 seconds of inactivity
                ${pkgs.enable-dpms}/bin/enable-dpms
            '';

            videoDrivers = [ "nvidia" ];
        };
    };
}
