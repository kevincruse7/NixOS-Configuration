{ config, lib, pkgs, stdenv }: pkgs.writeShellScriptBin "enable-dpms" ''
    ${pkgs.xorg.xset}/bin/xset dpms 30
''
