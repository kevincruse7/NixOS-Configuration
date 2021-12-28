{
    description = "My NixOS systems";

    inputs = {
        home-manager.url = github:nix-community/home-manager;
        nixos-hardware.url = github:NixOS/nixos-hardware;
    };

    outputs = { self, home-manager, nixos-hardware, nixpkgs }: {
        nixosConfigurations = {
            Kevin-Desktop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";

                modules = [
                    home-manager.nixosModules.home-manager

                    nixos-hardware.nixosModules.common-cpu-intel
                    nixos-hardware.nixosModules.common-pc
                    nixos-hardware.nixosModules.common-pc-ssd

                    ./system/desktop.nix
                ];
            };

            Kevin-Laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";

                modules = [
                    home-manager.nixosModules.home-manager

                    nixos-hardware.nixosModules.common-gpu-nvidia
                    nixos-hardware.nixosModules.dell-xps-15-7590

                    ./system/laptop.nix
                ];
            };
        };
    };
}
