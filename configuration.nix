{ config, lib, pkgs, modulesDir, ... }:
let sshKey = builtins.readFile ./sshKey;
in {
  networking.hostName = "roze";
  time.timeZone = "UTC";
  system.stateVersion = "22.05";

  environment.pathsToLink = [ "/share/zsh" ];
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
    openFirewall = true;
  };
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [ sshKey ];
  };
}
