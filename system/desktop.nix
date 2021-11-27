{config, pkgs, ...}:

with pkgs;
{
    imports = [
        ./common.nix
        ../modules/enigmatica-6-server

        <nixos-hardware/common/pc>
        <nixos-hardware/common/pc/ssd>
        <nixos-hardware/common/cpu/intel>
    ];


    boot.kernelParams = [ "nvidia-drm.modeset=1" ];


    environment.systemPackages = let
        enigmatica-6-server = callPackage ../pkgs/enigmatica-6-server {};
    in [
        enigmatica-6-server
    ];


    # Screen is high resolution, but not high DPI
    hardware.video.hidpi.enable = false;


    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
    };


    powerManagement.cpuFreqGovernor = "performance";


    services = {
        sshd.enable = true;

        xserver = {
            displayManager.setupCommands = let
                enable-dpms = callPackage ../pkgs/enable-dpms {};
            in ''
                # Force composition pipeline on to fix KDE lagginess
                ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --assign \
                    CurrentMetaMode="nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"

                # Turn screen off after 30 seconds of inactivity
                ${enable-dpms}/bin/enable-dpms
            '';

            videoDrivers = [ "nvidia" ];
        };
    };
}
