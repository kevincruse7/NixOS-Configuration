{pkgs, ...}:

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
    console.font = "Lat2-Terminus16";  # HiDPI defaults come out way too large


    environment.systemPackages = let
        enigmatica-6-server = callPackage ../pkgs/enigmatica-6-server {};
    in [
        enigmatica-6-server
    ];


    networking = {
        hostName = "Kevin-Desktop";
        interfaces.eno1.useDHCP = true;
    };


    powerManagement.cpuFreqGovernor = "performance";


    services = {
        sshd.enable = true;
        xserver.videoDrivers = [ "nvidia" ];
    };
}
