{ ... }: {
  imports = [
    ./hardware-configuration.nix
    
    
  ];
 nix.settings =  {
    experimental-features = [ "flakes" "nix-command" "repl-flake" ];
    keep-outputs = true;
    log-lines = 50;
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "cecile";
  networking.domain = "luxus.ai";
  services.openssh.enable = true;
  users.users.luxus.isNormalUser = true;
  users.users.luxus.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/AjBtg8D4lMoBkp2L3dDb5EmkOGr1v/Ns1wwRoKds4 luxus" 
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/AjBtg8D4lMoBkp2L3dDb5EmkOGr1v/Ns1wwRoKds4 luxus" 
  ];
}
