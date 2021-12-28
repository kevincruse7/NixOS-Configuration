{ pkgs, stdenv }: with pkgs; writeShellScriptBin "disable-dpms" ''
    ${xorg.xset}/bin/xset -dpms
''
