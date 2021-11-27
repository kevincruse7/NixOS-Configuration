{writeShellScriptBin, xset, ...}:

writeShellScriptBin "enable-dpms" ''
    ${xset}/bin/xset dpms 30
''
