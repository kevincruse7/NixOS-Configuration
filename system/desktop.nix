{ config, lib, pkgs, ... }: {
    imports = [
        ./common.nix
        ../modules/minecraftd
    ];

    boot = {
        kernelModules = [ "kvm-intel" ];
        kernelParams = [ "nvidia-drm.modeset=1" ];

        initrd.availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usb_storage"
            "usbhid"
            "sd_mod"
            "sr_mod"
        ];
    };

    hardware.enableRedistributableFirmware = true;
    home-manager.users.kevin = import ../user/desktop.nix;

    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
    };

    powerManagement.cpuFreqGovernor = "performance";

    services = {
        minecraftd.enable = true;
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
