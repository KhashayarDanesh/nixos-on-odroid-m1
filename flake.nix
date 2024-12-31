{
  description = "Nix image for odroid M1";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
  outputs = { self, nixpkgs }: rec {
    nixosConfigurations.m1 = nixpkgs.lib.nixosSystem {
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${fetchTarball {url="https://github.com/KhashayarDanesh/nixos-hardware/tarball/master"; sha256="11698l6r6p0jajd0c2rda0ipi54yi26wrj32a006256axvzz6wqh";}}/hardkernel/odroid-m1"
        ./sdimageconfiguration.nix
        {
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.hostPlatform.system = "aarch64-linux";
          nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.     
        }
      ];
    };
    images.m1 = nixosConfigurations.m1.config.system.build.sdImage;
  };
}
