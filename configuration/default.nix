{ config, lib, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./virtualisation.nix
    ./ioover.net.nix
    ./nix.nix
  ];

  networking.hostName = "roze";
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

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
