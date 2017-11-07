{ pkgs, config, ... }:

let

  inherit (builtins) elem;
  inherit (pkgs.stdenv) isLinux;

  isNixOS = builtins.pathExists /etc/NIXOS;
  hostname = builtins.getEnv "HOSTNAME";

  isHomeMachine = elem hostname ["howard"];
  isWorkMachine = elem hostname [ ];

in
{
  withAndroidDev   = isHomeMachine;
  withFirefox      = true;
  withChromium     = true;
  withDigikam      = false;
  withEvince       = isLinux;
  withGames        = isHomeMachine;
  withInkscape     = isLinux;
  withLatex        = isLinux;
  withLibreOffice  = isLinux;
  withMega         = false;
  withPopfile      = false;
  withPyCharm      = false;
  withUrxvt        = true;
  withIdea         = true;
  withX11          = isNixOS;
  withExtraKdeApps = false;
  withXmonad       = isLinux;
  withEmail	   = isHomeMachine;
}
