{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Omarchy’s stock theme handling.
  programs.nixarchyThemeEngine.enable = false;

  programs.nixarchy = {
    enable = true;
    user = "adamf";
    flake = "/home/adamf/nixos-config";
    menu.default = "omarchy";
    defaultAgent = "codex";
    shellIntegration = false;
  };

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  networking.firewall.interfaces.enp4s0.allowedTCPPorts = [ 22 ];
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "adamf" ];
      PasswordAuthentication = true;
    };
  };

  time.timeZone = "Australia/Sydney";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;

  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    promptInit = ''
      if [[ $TERM != dumb ]]; then
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
    shellAliases.ls = "eza";
  };

  users.users."adamf" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Adam Farrell";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = 2;
    cores = 2;
  };

  zramSwap.enable = true;

}
