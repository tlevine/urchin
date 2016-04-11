# A NixOS container to protect against accidental fork bombs
#
# Put this in /var/lib/containers/test/etc/nixos/configuration.nix
# See https://nixos.org/wiki/NixOS:Containers

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
};
