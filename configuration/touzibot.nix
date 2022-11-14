{ config, ... }: {
  age.secrets.touzibotEnv.file = ../secrets/touzibot.env.age;
  virtualisation.oci-containers.containers = {
    touzibot = {
      image = "ghcr.io/mythal/telegram-dice-bot:production";
      autoStart = true;
      extraOptions = [ ];
      environmentFiles = [ config.age.secrets.touzibotEnv.path ];
    };
  };
}
