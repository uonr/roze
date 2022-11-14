{ ... }:
let port = 8080; in {
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "whoooa/ioover.net";
      autoStart = true;
      ports = [ "127.0.0.1:${toString port}:80" ];
      extraOptions = [ "--pull=always" ];
    };
  };
}
