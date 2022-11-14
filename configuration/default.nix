{ config, lib, pkgs, ... }: {
  imports = [
    ./linode.nix
    ./users.nix
    ./virtualisation.nix
    ./ioover.net.nix
    ./nix.nix
    ./touzibot.nix
  ];

  networking.hostName = "roze";
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  age.secrets.wiredHostKey.file = ../secrets/wired.host.key.age;
  age.secrets.wiredHostCert.file = ../secrets/wired.host.crt.age;
  services.wired = {
    enable = true;
    isLighthouse = true;
    key = config.age.secrets.wiredHostKey.path;
    cert = config.age.secrets.wiredHostCert.path;
  };
  time.timeZone = "UTC";
  system.stateVersion = "22.05";

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  programs.mosh.enable = true;

  services.vscode-server.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
    openFirewall = true;
  };
}
