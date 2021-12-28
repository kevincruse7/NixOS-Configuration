{ pkgs, stdenv }: with pkgs; writeShellScriptBin "enable-dpms" ''
    ${xorg.xset}/bin/xset dpms 30
''
