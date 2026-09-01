{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # OrbStack's generated host must be included before any Host blocks.
    includes = [ "~/.orbstack/ssh/config" ];
    settings = {
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "*" = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
        ServerAliveInterval = 60;
      };
    };
  };
}
