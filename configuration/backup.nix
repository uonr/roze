{ ... }: {
  services.borgbackup.jobs.doll = {
    paths = [
      "/var/lib/isso"
    ];
    encryption.mode = "none";
    compression = "auto,lzma";
    startAt = "daily";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = -1;  # Keep at least one archive for each month
    };
    doInit = true;
    repo = "borg@10.110.100.12:.";
    environment = { BORG_RSH = "ssh -i /etc/ssh/ssh_host_ed25519_key"; };
  };
}
