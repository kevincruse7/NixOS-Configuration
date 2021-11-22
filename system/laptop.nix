{pkgs, ...}:

with pkgs;
{
    imports = [
        ./common.nix

        <nixos-hardware/dell/xps/15-7590>
        <nixos-hardware/common/gpu/nvidia.nix>
    ];


    # Use more power efficient deep sleep
    boot.kernelParams = [ "mem_sleep_default=deep" ];


    hardware = {
        bluetooth.enable = true;

        nvidia.prime = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };


    networking = {
        hostName = "Kevin-Laptop";
        interfaces.wlp59s0.useDHCP = true;
    };


    services = {
        hardware.bolt.enable = true;
        logind.lidSwitch = "lock";

        tlp = {
            enable = true;

            settings = {
                CPU_MIN_PERF_ON_AC = 0;
                CPU_MAX_PERF_ON_AC = 100;
                CPU_MIN_PERF_ON_BAT = 0;
                CPU_MAX_PERF_ON_BAT = 30;

                CPU_SCALING_GOVERNOR_ON_AC = "performance";
            };
        };

        # Fix monitor configuration in SDDM
        xserver.displayManager.setupCommands = ''
            ${xorg.xrandr}/bin/xrandr \
                --output eDP-1 --mode 1920x1080 --pos 1920x0 \
                --output DP-1 --mode 1920x1080 --pos 0x0 --rate 60
        '';
    };
}
