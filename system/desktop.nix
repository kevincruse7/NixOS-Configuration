{ config, lib, pkgs, ... }: {
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
    hardware.video.hidpi.enable = false;  # Screen is high resolution, but not high DPI
    powerManagement.cpuFreqGovernor = "performance";

    environment.systemPackages = let
        minecraft-server = pkgs.callPackage ../pkgs/minecraft-server {};
    in [ minecraft-server ];

    imports = [
        <nixos-hardware/common/cpu/intel>
        <nixos-hardware/common/pc>
        <nixos-hardware/common/pc/ssd>

        ./common.nix
        ../modules/minecraft-server
    ];

    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
    };

    services = {
        sshd.enable = true;

        xserver = {
            videoDrivers = [ "nvidia" ];

            displayManager.setupCommands = let
                enable-dpms = pkgs.callPackage ../pkgs/enable-dpms {};
            in ''
                # Force composition pipeline on to fix KDE lagginess
                ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign \
                    CurrentMetaMode="nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"

                # Turn screen off after 30 seconds of inactivity
                ${enable-dpms}/bin/enable-dpms
            '';
        };
    };
}
