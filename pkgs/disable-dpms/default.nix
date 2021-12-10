{config, lib, pkgs, stdenv}: pkgs.writeShellScriptBin "disable-dpms" ''
    ${pkgs.xorg.xset}/bin/xset -dpms
''
