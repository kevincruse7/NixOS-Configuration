{pkgs, ...}:

with pkgs;
{
    imports = [ ./common.nix ];


    programs.git.extraConfig.credential.helper = git.override {
        withLibsecret = true;
    } + "/bin/git-credential-libsecret";
}
