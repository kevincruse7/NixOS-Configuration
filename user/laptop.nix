{pkgs, ...}:

with pkgs;
{
    imports = [ ./common.nix ];


    home.file.".config/monitors.xml".source = let
        monitors-xml = callPackage ../pkgs/monitors-xml {};
    in
        monitors-xml;


    programs.git.extraConfig.credential.helper = git.override {
        withLibsecret = true;
    } + "/bin/git-credential-libsecret";
}
