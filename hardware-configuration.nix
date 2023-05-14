{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  fileSystems."/" = { device = "/dev/disk/by-label/cecile"; fsType = "ext4"; };

}
