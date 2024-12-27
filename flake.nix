{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = nixpkgs.lib;
  in rec {
    devShell.${system} = pkgs.mkShell {
      buildInputs = with pkgs; [
        rsync
        zstd
        git
      ];
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.m1 = lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        ({
          pkgs,
          config,
          ...
        }: {
          imports = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            "${fetchTarball {url="https://github.com/KhashayarDanesh/nixos-hardware/tarball/master"; sha256="11698l6r6p0jajd0c2rda0ipi54yi26wrj32a006256axvzz6wqh";}}/hardkernel/odroid-m1"
            ./sdimageconfiguration.nix
          ];

          sdImage = {
            compressImage = false;
            populateFirmwareCommands = let
              configTxt = pkgs.writeText "README" ''
                Nothing to see here. This empty partition is here because I don't know how to turn its creation off.
              '';
            in ''
              cp ${configTxt} firmware/README
            '';
            populateRootCommands = ''
              ${config.boot.loader.kboot-conf.populateCmd} -c ${config.system.build.toplevel} -d ./files/kboot.conf
            '';
          };

          # Enable nix flakes
          nix.package = pkgs.nix;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          environment.systemPackages = [
            pkgs.git #gotta have git
          ];

          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
          };
          users.extraUsers.root.initialPassword = lib.mkForce "odroid";
        })
      ];
    };

    images = {
      m1 = nixosConfigurations.m1.config.system.build.sdImage;
    };
  };
}
