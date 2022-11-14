{ config, pkgs, ... }:
let
  port = 8080;
  issoPort = 8081;
in {
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "acme@ioover.net";
  services.nginx.enable = true;
  services.nginx.virtualHosts."ioover.net" = {
    serverAliases = [ "www.ioover.net" ];
    enableACME = true;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
    locations."/isso" = {
      proxyPass = "http://127.0.0.1:${toString issoPort}";
      extraConfig = ''
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Script-Name /isso;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
  users.groups.isso = { gid = 8192; };
  users.users.isso = {
    uid = 8192;
    group = "isso";
    isSystemUser = true;
    home = "/var/lib/isso";
    createHome = true;
  };

  age.secrets.issoConfig = {
    file = ../secrets/isso.cfg.age;
    owner = "isso";
    group = "isso";
  };
  systemd.services.isso = {
    description = "isso, a commenting server similar to Disqus";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "isso";
      Group = "isso";

      WorkingDirectory = "/var/lib/isso";

      ExecStart = ''
        ${pkgs.isso}/bin/isso -c ${config.age.secrets.issoConfig.path}
      '';

      Restart = "on-failure";
      RestartSec = 1;
    };
  };
  virtualisation.oci-containers.containers = {
    ioover_net = {
      image = "whoooa/ioover.net";
      autoStart = true;
      ports = [ "127.0.0.1:${toString port}:80" ];
      extraOptions = [ ];
    };
  };
}
