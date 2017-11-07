{ pkgs, config, ... }:
{

  ################################################################################
  # environment
  nixpkgs.config.allowUnfree = true;
  boot.cleanTmpDir = true;

  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  environment.systemPackages = with pkgs;
       [ file htop hwdata iotop lsof lshw lsscsi nethogs pciutils psmisc which smartmontools xsettingsd usbutils bind inetutils powertop ]
    ++ [ termite.terminfo rxvt_unicode.terminfo ]
    ++ [ nix-serve nix-prefetch-git nix-prefetch-hg nix-prefetch-svn nix-prefetch-scripts ]
    ++ [ wget curl ]
    ++ [ vim ]
    ++ [ gitAndTools.gitFull ]
    ++ [ mkpasswd yadm ];

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  ################################################################################
  # nix configuration
  nix = {
    useSandbox = true;
    trustedBinaryCaches = [ https://cache.nixos.org ];
    binaryCaches = [ https://cache.nixos.org ];
    extraOptions = "binary-caches-parallel-connections = 25";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  ################################################################################
  # networking
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  ################################################################################
  # security
  security = {
    pam = {
      enableSSHAgentAuth = true;
      mount.enable = true;
    };
    polkit.enable = true;
  };

  ################################################################################
  # services
  services = {
    ntp.enable = true;
    smartd.enable = true;
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    journald.extraConfig = ''
      SystemMaxUse=50M
      SystemMaxFileSize=10M
    '';
    nixosManual.showManual = true;
  };

  ################################################################################
  # system
  powerManagement.enable = true;
  system.autoUpgrade.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}

