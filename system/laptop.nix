{ config, lib, pkgs, ... }: {
    boot.kernelParams = [ "mem_sleep_default=deep" ];  # Use more power efficient deep sleep

    hardware = {
        bluetooth.enable = true;

        nvidia = {
            nvidiaSettings = false;  # Settings application not needed with PRIME offload

            # More efficient dGPU power management with PRIME offload
            powerManagement.finegrained = true;

            prime = {
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
            };
        };
    };

    imports = [
        <nixos-hardware/common/gpu/nvidia.nix>
        <nixos-hardware/dell/xps/15-7590>

        ./common.nix
    ];

    networking = {
        hostName = "Kevin-Laptop";
        interfaces.wlp59s0.useDHCP = true;
    };

    services = {
        hardware.bolt.enable = true;
        logind.lidSwitch = "lock";

        tlp.settings = {
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MAX_PERF_ON_BAT = 30;
            CPU_MIN_PERF_ON_AC = 0;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
        };

        xserver = {
            displayManager.setupCommands = let
                enable-dpms = pkgs.callPackage ../pkgs/enable-dpms {};
            in ''
                # Fix monitor configuration
                ${pkgs.xorg.xrandr}/bin/xrandr \
                    --output eDP-1 --mode 1920x1080 --pos 1920x0 \
                    --output DP-1 --mode 1920x1080 --pos 0x0 --rate 60

                # Turn screen off after 30 seconds of inactivity
                ${enable-dpms}/bin/enable-dpms
            '';
        };
    };
}
