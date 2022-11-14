{ ... }:
let port = 8080; in {
  services.nginx.enable = true;
  services.nginx.virtualHosts."ioover.net" = {
    serverAliases = [
      "stage.ioover.net"
    ];
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
