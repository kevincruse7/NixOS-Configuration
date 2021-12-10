{config, lib, pkgs, stdenv}: stdenv.mkDerivation {
    pname = "enigmatica-6-server";
    version = "0.5.9";

    buildInputs = [ pkgs.makeWrapper ];

    srcs = [
        (
            pkgs.fetchFromGitHub {
                name = "server-files";
                owner = "NillerMedDild";
                repo = "Enigmatica6";
                rev = "0.5.10";
                sha256 = "0d39ix8vpcq7j65yc9dqzjpcllphbazhq4i7vabvvp8ld55364n4";
            }
        )
        (
            pkgs.fetchgit {
                name = "daemon-files";
                url = "https://aur.archlinux.org/minecraft-server.git";
                rev = "ce8d2b69e85568bed0fe5c878de383f39d18501f";  # Version 1.17.1-2
                sha256 = "0zr1jsq5p7s68d2xbfd7004fhwwqkm58hxrz0avdyff8wzdc61ym";
            }
        )
    ];
    sourceRoot = "/build";

    # Strip carriage returns from server-setup-config.yaml
    prePatch = ''
        cd server-files/server_files
        mv server-setup-config.yaml server-setup-config.yaml.old
        tr -d "\r" < server-setup-config.yaml.old > server-setup-config.yaml
        cd $sourceRoot
    '';

    patches = [
        ./server-files.patch
        ./daemon-files.patch
    ];

    installPhase = ''
        ### etc ###

        install -Dm 644 server-files/server_files/server-setup-config.yaml $out/etc/server-setup-config.yaml
        install -Dm 644 daemon-files/minecraftd.conf $out/etc/minecraft

        ### lib ###

        install -Dm 755 server-files/server_files/start-server.sh $out/lib/start-server-base.sh
        install -Dm 755 daemon-files/minecraftd.sh $out/lib/minecraftd-base.sh

        makeWrapper $out/lib/start-server-base.sh $out/lib/start-server.sh --prefix PATH : ${with pkgs; lib.makeBinPath [
            coreutils
            gawk
            gnugrep
            jdk8
            util-linux
            wget

            # Use sudo wrapper with setuid bit enabled
            "/run/wrappers"
            sudo
        ]}

        ### bin ###

        makeWrapper $out/lib/minecraftd-base.sh $out/bin/minecraftd --prefix PATH : ${with pkgs; lib.makeBinPath [
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
        ]}
    '';

    # Replace @out@ references with Nix store directory
    postFixup = ''
        substituteAllInPlace $out/etc/minecraft
        substituteAllInPlace $out/lib/start-server-base.sh
        substituteAllInPlace $out/lib/minecraftd-base.sh
    '';
}
