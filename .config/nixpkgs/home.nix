{ ... }:

# use a pinned version of nixpkgs, bypassing nix-channel:
with import ./pin.nix;

let

  myOptions = callPackage ./packageChoices.nix { };
  lockCmd = "gnome-screensaver-command -l";
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
        terminal = "${pkgs.enlightenment.terminology}/bin/terminology";
        xmobar = "${pkgs.haskellPackages.xmobar}/bin/xmobar";
        rofi = "${pkgs.rofi}/bin/rofi";
        browser = "${pkgs.firefox}/bin/firefox";
        lockCmd = lockCmd;
      } ''
        substituteAll ${./xmonad.hs} $out
      '';
    };
    initExtra = ''
      autorandr -c
    '';
  };

  programs = {
  
    home-manager = {
      enable = true;
      path = "./home-manager";
    };

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

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Jean-Baptiste Giraudeau";
      userEmail = if isWorkMachine then "jb.giraudeau@lombardodier.com" else "jb@giraudeau.info";
      signing = {
        key = if isWorkMachine then "A8396FDB" else "50267CD1";
	signByDefault = true;
      };
      aliases = {
	pushf = "push --force-with-lease";
      };
      extraConfig = ''
[push]
  followTags = true
[url "https://github.com/"]
  insteadOf = git@github.com:
[url "https://github.com"]
  insteadOf = git://github.com
[filter "lfs"]
  process = git-lfs filter-process
  required = true
  clean = git-lfs clean -- %f
  smudge = git-lfs smudge -- %f
'';
      ignores = [ "/.idea" "*.iws" "*.iml" "*.ipr" "/.idea_modules" ".ensime*" "ensime-langserver.log" ];
    };

    firefox = {
      enable = withFirefox;
      enableAdobeFlash = true;
    };

    fzf.enable = true;

    command-not-found.enable = true;
  };

 systemd.user.startServices = true;

  services = {

    unclutter.enable = true;
  
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  
    redshift = {
      enable = true;
      latitude = "46.1835";
      longitude = "6.1002";
    };
  
    screen-locker = {
      enable = true;
      lockCmd = lockCmd;
    };
  
    syncthing.enable = isHomeMachine;
    gnome-keyring.enable = true;
    network-manager-applet.enable = true;
  };

  # man home-configuration.nix
  manual.manpages.enable = true;

}
