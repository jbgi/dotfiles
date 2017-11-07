{ ... }:

# use a pinned version of nixpkgs, bypassing nix-channel:
with import ./pin.nix;

let

  myOptions = callPackage ./packageChoices.nix { };

in 
  with myOptions; {

  home = {

    language = {
      base = "en_US.utf8";
      address = "fr_CH.utf8";
      monetary = "fr_CH.utf8";
      paper = "fr_CH.utf8";
      time = "fr_CH.utf8";
    };
  
    keyboard = {
      layout = "ch";
      variant = "fr";
    };
   
    sessionVariables = {
      EDITOR = "nvim";
    };
    
#    sessionVariableSetter = "zsh";

    packages = import ./packages.nix { inherit pkgs myOptions;};
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.runCommand "xmonad.hs" {
        xmobar = "${pkgs.haskellPackages.xmobar}/bin/xmobar";
        rofi = "${pkgs.rofi}/bin/rofi";
        browser = "${pkgs.firefox}/bin/firefox";
        lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
      } ''
        substituteAll ${./xmonad.hs} $out
      '';
    };
  };

  programs = {
  
    zsh = {
      enable = true;
      
      oh-my-zsh = {
        enable = true;
        theme = "refined";
        plugins = [ "sudo" "git" "git-extras" "github" "tmux" "systemd" "cabal" "gpg-agent" ];
      };
    };
  
    gnome-terminal = {
      enable = true;
      showMenubar = false;
      profile."default" = {
        visibleName = "default";
        default = true;
      };
    };
  
    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };
    
    neovim = {
      enable = true;
    };

    firefox = {
      enable = withFirefox;
      enableAdobeFlash = true;
    };
    command-not-found.enable = true;
  };

 systemd.user.startServices = true;

  services = {
  
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  
    compton = {
      enable = true;
      fade = true;
      shadow = true;
    };
  
    redshift = {
      enable = true;
      latitude = "46.1835";
      longitude = "6.1002";
    };
  
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
    };
  
    syncthing.enable = true;
    gnome-keyring.enable = true;
    network-manager-applet.enable = true;
  };

  # man home-configuration.nix
  manual.manpages.enable = true;

}
