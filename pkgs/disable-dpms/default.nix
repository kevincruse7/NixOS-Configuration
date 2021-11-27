{writeShellScriptBin, xset, ...}:

writeShellScriptBin "disable-dpms" ''
    ${xset}/bin/xset -dpms
''
