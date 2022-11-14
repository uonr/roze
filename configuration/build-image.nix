{ config, lib, pkgs, modulesPath, ... }: {

  system.build.linode =
    import "${toString modulesPath}/../lib/make-disk-image.nix" {
      inherit lib config pkgs;
      partitionTableType = "none";
      format = "raw";
      postVM = ''
        ${pkgs.pigz}/bin/pigz -9 $out/nixos.img
      '';
    };
}
