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


    hardware.nvidia = {
        prime = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };

        nvidiaPersistenced = true;  # Keep GPU powered on, as GDM fails to activate it otherwise
    };


    networking = {
        hostName = "Kevin-Laptop";
        interfaces.wlp59s0.useDHCP = true;
    };


    powerManagement.cpuFreqGovernor = "ondemand";


    services = {
        logind.lidSwitch = "lock";
        power-profiles-daemon.enable = false;

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
    };


    systemd.tmpfiles.rules = let
        monitors-xml = callPackage ../pkgs/monitors-xml {};
    in [
        "L+ /run/gdm/.config/monitors.xml - - - - ${monitors-xml}"
    ];
}
