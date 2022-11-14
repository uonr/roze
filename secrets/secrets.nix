# https://github.com/ryantm/agenix
let
  roze = builtins.readFile ../keys/roze.id-ed25519.pub;
  kiyomi = builtins.readFile ../keys/kiyomi.id-rsa.pub;
  koma = builtins.readFile ../keys/koma.id-ed25519.pub;
in {
  "wired.host.key.age".publicKeys = [ roze ];
  "wired.host.crt.age".publicKeys = [ roze ];
  "touzibot.env.age".publicKeys = [ roze ];
  "isso.cfg.age".publicKeys = [ roze kiyomi koma ];
}

