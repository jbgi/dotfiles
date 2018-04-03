{ pkgs, config, ... }:

let

  inherit (builtins) elem;
  inherit (pkgs.stdenv) isLinux;

  isNixOS = builtins.pathExists /etc/NIXOS;
  user = builtins.getEnv "USER";

  isHomeMachine = elem user ["jbgi"];
  isWorkMachine = elem user ["giraudeau"];

in
{
  withNix           = !isNixOS;
  isWorkMachine     = isWorkMachine;
  isHomeMachine     = isHomeMachine;
  withAndroidDev    = isHomeMachine;
  withFirefox       = true;
  withChromium      = true;
  withChrome        = false;
  withDigikam       = false;
  withEvince        = isLinux;
  withGames         = isHomeMachine;
  withInkscape      = isLinux;
  withLatex         = isLinux;
  withLibreOffice   = isLinux;
  withMega          = false;
  withPopfile       = false;
  withPyCharm       = false;
  withUrxvt         = true;
  withIdea          = true;
  withX11           = isNixOS;
  withExtraKdeApps  = false;
  withXmonad        = isLinux;
  withEmail	    = isHomeMachine;
  withSlack         = isWorkMachine;
  withRemoteWindows = isWorkMachine;
  withMongo         = isWorkMachine;
  withMysql         = isWorkMachine;
}
