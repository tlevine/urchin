# A NixOS container to protect against accidental fork bombs
#
# Put this in /var/lib/containers/test/etc/nixos/configuration.nix
# See https://nixos.org/wiki/NixOS:Containers
{ config, lib, pkgs, ... }:
   
with lib;
 
{ boot.isContainer = true;
  networking.hostName = mkDefault "urchin";
  networking.useDHCP = false;

  environment.systemPackages = with pkgs; [
    busybox
    bash dash mksh zsh
  ];

  users.extraUsers.user = {
    name = "tlevine";
    group = "users";
    uid = 1000;
    createHome = true;
    home = "/home/tlevine";
    extraGroups = [ "users" "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGvQyzr42/96acUTUedaeM2ee+DMt9bkxeurdeXji9sNE10MjjAUFtxPmSI8/BUZW2/a9ByblfaJEI+H+kFVPjVr+QGKXZluxcFMj2BLbH53fi9xLgoQRjb2aAXutb2Bp74/E8R1K+CuFfRRGQ5Spdnv44SLt04D6JbBLcLIcWTpQ4v5RaYr2U27jfiF9z0m+/opxvowEy2gnqlEXFxFk8jZHT4K0uLWm2ENjT6OpyOx8hWcKeAN2vRVRex3pJfSzswn0LpuCrM1rUZ4DRE+FABi8N21Q3MBaMRkwnZPwaZwKzv06q8bu23jYTqK5BrUPtOXeeVuroQXMc12H/6/Nh laptop"
    ];
  };
}
