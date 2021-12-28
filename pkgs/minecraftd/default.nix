{ pkgs, stdenv }: with pkgs; let
    minecraftVersion = "1.18.1";
    paperBuild = "76";

    serverJar = fetchurl {
        name = "minecraft_server.jar";

        url = "https://papermc.io/api/v2/projects/paper/versions/${minecraftVersion}/builds"
            + "/${paperBuild}/downloads/paper-${minecraftVersion}-${paperBuild}.jar"
        ;

        sha256 = "0zn69r95p1gzpnxfb228slbiwhx0la684s52wapywcv90ayp4xx5";
    };
in stdenv.mkDerivation {
    pname = "minecraftd";
    version = "${minecraftVersion}-${paperBuild}";

    inherit bash serverJar;

    buildInputs = [ makeWrapper ];
    preferLocalBuild = true;

    src = fetchgit {
        url = "https://aur.archlinux.org/minecraft-server.git";
        rev = "78db11d1445885b0e0d7a01b022b212173e79182";  # Version 1.18.1-1
        sha256 = "0rrjnwxbc4gqd435b7gx7115iqy45gxczx1i63p426za44dxkgzr";
    };

    patches = [ ./daemon-files.patch ];

    installPhase = ''
        # etc
        install -D --mode=644 --target-dir="$out/etc/" ./minecraftd.conf

        # share
        install -D --mode=755 ./minecraftd.sh "$out/share/minecraftd-base.sh"

        # bin
        makeWrapper "$out/share/minecraftd-base.sh" "$out/bin/minecraftd" \
            --prefix PATH : "${lib.makeBinPath [
                coreutils
                gawk
                gnugrep
                gnused
                gnutar
                procps
                tmux

                # Use sudo wrapper with setuid bit enabled
                "/run/wrappers"
                sudo
            ]}"
    '';

    # Substitute environment variable references
    postFixup = ''
        substituteAllInPlace "$out/etc/minecraftd.conf"
        substituteAllInPlace "$out/share/minecraftd-base.sh"
    '';
}
