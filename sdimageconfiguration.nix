{ config, pkgs, lib, ... }:
{
  system.stateVersion = lib.mkDefault "24.11";

  imports = [
    #"${fetchTarball "https://github.com/KhashayarDanesh/nixos-hardware/tarball/master"}/hardkernel/odroid-m1"
    "${fetchTarball {url="https://github.com/KhashayarDanesh/nixos-hardware/tarball/master"; sha256="11698l6r6p0jajd0c2rda0ipi54yi26wrj32a006256axvzz6wqh";}}/hardkernel/odroid-m1/"
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.extraUsers.root.initialPassword = lib.mkForce "odroid";
  users.users.root.openssh.authorizedKeys.keys =  [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGViv0xBt1nxIcFIL2TG2E7TPY6OVMZrtAY+WwVbBIbx khashayar@tangerine.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlKj4SAmCOccg09PDN15uPsF5PqbL/Cvepjuw28RKZe khashayar@deepthought.local" 
    ];
}