{ pkgs, ... }:
let
  sshKeys = [
    (builtins.readFile ../keys/kiyomi.id-rsa.pub)
    (builtins.readFile ../keys/koma.id-ed25519.pub)
  ];
in {
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "!";
    openssh.authorizedKeys.keys = sshKeys;
    shell = pkgs.zsh;
  };

  home-manager.users.root = { ... }: {
    home.my = {
      enable = true;
      development = false;
      gui = false;
      entertainment = false;
      lite = true;
    };
  };
  users.users.mikan = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = sshKeys;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.mikan = { ... }: {
    home.my = {
      enable = true;
      development = false;
      gui = false;
      entertainment = false;
      lite = true;
    };

    programs.git = {
      userEmail = "me@yuru.me";
      userName = "Tachibana Kiyomi";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
