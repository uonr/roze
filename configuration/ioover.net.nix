{ ... }:
let port = 8080; in {
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "acme@ioover.net";
  services.nginx.enable = true;
  services.nginx.virtualHosts."stage.ioover.net" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };
  virtualisation.oci-containers.containers = {
    ioover_net = {
      image = "whoooa/ioover.net";
      autoStart = true;
      ports = [ "127.0.0.1:${toString port}:80" ];
      extraOptions = [ "--pull=always" ];
    };
  };
}
