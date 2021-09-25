{...}:

{
    imports = [ ./common.nix ];
    programs.git.extraConfig.credential.helper = "store";
}
