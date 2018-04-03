{ pkgs, myOptions, ... }:

with import ./pin.nix;
let

  inherit (stdenv.lib) optional optionals;
  inherit (stdenv) isLinux;
  
  devHaskell = haskellPackages.ghcWithHoogle (
        hspkgs: with hspkgs; [ ]
    );

  citrixReceiver = pkgs.citrix_receiver.overrideAttrs (oldAttrs: {
    src = requireFile rec {
      name = "linuxx64-13.9.1.6.tar.gz";
      sha256 = "1g15b7fs8f5ryz38524x1qrjghmp78y0wyj426mfi1y2x1y1bad9";
      message = "msg";
    };
    });

  args = {inherit pkgs config stdenv;} // myOptions;

in
  with args;
    ### KDE
    optionals withExtraKdeApps [
            ark 
            gwenview
            okular
            yakuake
            spectacle
            kate
            kcalc
            klavaro
          ]

    ### cloudfs / synchronization
    ++ optional withMega    megatools
    ++ optional isLinux      unison

    ### development
    ++ [ autoconf gnumake gcc silver-searcher colordiff direnv vscode meld binutils pythonFull ]
    ++ [
       openjdk
       scala
       ammonite-repl
       sbt
       scalafmt
       maven
       gradle
       visualvm
       idea.idea-community
    ]
    ++ [ rustc cargo rustfmt rustracer ]
    ++ optional withPyCharm idea.pycharm-community

    ### development / cloud
    ++ [ nixops terraform ]

    ### development / git tools
    ++ (with gitAndTools;
       [ hub git-extras topGit # gitchangelog
         git-crypt git-lfs
       ])
    ++ [ mercurialFull travis ]

    # ### development
    ++ [ devHaskell cabal-install cabal2nix hlint haskellPackages.stylish-haskell haskellPackages.hasktags ]
    ++ optionals withMongo [ mongodb mongodb-tools robo3t ]
    #++ [ sqlite sqlitebrowser ]
    ++ [ source-code-pro nwjs_0_12 ]
    ++ optional withSlack slack 
    ++ optionals withAndroidDev [ androidsdk adb-sync adbfs-rootless ]
    ++ optional withMysql mysql-workbench

    # ### finance
    ++ (with haskellPackages;
       [ hledger
         # hledger-ui
         # hledger-web
         # hledger-diff # broken in 2016/12/05
       ])
    ++ [ gnuplot ]

    ### games

    ### monitoring
    ++ optionals isLinux [ iotop htop nethogs ]

    ### media
    ++ [vlc mplayer mpv mtpfs pavucontrol ]

    ### nix
    ++ [ nix-repl ] ++ optional withNix nix

    ### office / productivity
    ++ [ gimp xournal ]
    ++ optional  withEvince evince
    ++ optionals withInkscape    [ inkscape ]
    ++ optionals withLatex       [ texlive.combined.scheme-full biber ]
    ++ optional  withLibreOffice libreoffice
    ++ optional  withPopfile     popfile
    ++ optionals withDigikam     [digikam5 fdupes perlPackages.ImageExifTool]
    ++ optionals withRemoteWindows [ freerdp remmina rdesktop citrixReceiver ]

    # security
    ++ [ gnupg gnutls pinentry keychain keepass keepassx2 keybase ]
    ++ optional  isLinux paperkey

    ### tools
    ++ [ aspell aspellDicts.en aspellDicts.fr
         yadm
         bc
         graphviz-nox
         imagemagick
         inotify-tools
         libav
         rsync
         gparted
         most
         mediainfo
         tree
         unison
         unzipNLS
         zip
         redshift
         geoclue
         wine
         mono
         tmux
       ]
    ++ optional isLinux aria

    ### web / network
    ++ [ weechat httpie jq nmap w3m ]
    ++ optional withChromium chromium 
    ++ optional withChrome google-chrome
    ++ optionals withUrxvt   [ rxvt_unicode_with-plugins
                               urxvt_font_size
                               urxvt_perl
                               urxvt_perls
                               urxvt_tabbedex
                               urxvt_theme_switch
                               urxvt_vtwheel
                             ]

    ### X11, window management
    ++ [ screen tmux ]                     # terminal multiplexers
    ++ [ enlightenment.terminology ]       # terminals
    ++ [ arandr autorandr xclip xsel xdotool i3lock         # X management
         gnome3.gnome_keyring gnome3.gsettings_desktop_schemas ]
    ++ [ feh rofi ]                        # X tools
    ++ (with xorg; [xev xbacklight xmodmap ])
    ++ [ networkmanagerapplet pa_applet    # applets
         parcellite ]

    ### XMonad
    ++ [ dmenu trayer haskellPackages.xmobar ]

    ### Home
    ++ optional withEmail thunderbird

