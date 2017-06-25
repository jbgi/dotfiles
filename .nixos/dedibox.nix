{ config, pkgs, ... }:

{

  imports = [
    ./dedibox/hardware-configuration.nix
    ./basicSystem.nix
    ./users.nix
  ];
  
  
  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
  
  systemd.enableEmergencyMode = false;
  
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
  
  
  fileSystems = {
    "/".options = [ "noatime" "noacl" ];
  };

  networking = {
    hostName = "dedibox"; # Define your hostname.
    hostId = "b2a3ac99";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
  };

}

