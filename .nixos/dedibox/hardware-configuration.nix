{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ahci" ];
  boot.kernelModules = [ "kvm-intel" "crc32c-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  nix.maxJobs = lib.mkDefault 2;
}
 
