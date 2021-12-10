{config, lib, pkgs, ...}: {
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
    hardware.video.hidpi.enable = false;  # Screen is high resolution, but not high DPI
    powerManagement.cpuFreqGovernor = "performance";

    environment.systemPackages = let
        enigmatica-6-server = pkgs.callPackage ../pkgs/enigmatica-6-server {};
    in [
        enigmatica-6-server
    ];

    imports = [
        ./common.nix
        ../modules/enigmatica-6-server
        <nixos-hardware/common/pc>
        <nixos-hardware/common/pc/ssd>
        <nixos-hardware/common/cpu/intel>
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
                enable-dpms = callPackage ../pkgs/enable-dpms {};
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
