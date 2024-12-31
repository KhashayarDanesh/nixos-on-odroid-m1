{ config, pkgs, lib, ... }:
{
  system.stateVersion = lib.mkDefault "24.11";

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