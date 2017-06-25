{ config, pkgs, ... }:
{
  users.extraUsers.jbgi = {
    isNormalUser = true;
    initialHashedPassword = "$6$Ds9uM3gi$Fl9.xtMKaCognxZuuFPYr6/b8uhZ6Aee1rVg8gjUaKgfJ0pen7mTjTvfKD6AuxBgv.A6IbucaJKj5iFw0ffHs0";
    createHome = true;
    extraGroups = with pkgs.stdenv.lib; [
    ] ++ optional config.networking.networkmanager.enable "networkmanager"
      ++ optional config.security.sudo.enable "wheel"
      ++ optional config.services.printing.enable "lp"
      ++ optional config.virtualisation.docker.enable "docker"
      ++ optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ optional config.virtualisation.virtualbox.host.enable "vboxusers";
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOdrHC+zcP4K/q246QJNTKd4PeSOydWJxVk1k7vVCOCeE310UWWljbmfRwWRvJw8snmwBl/VrB2B+jnij4Tmaqm37fHA6+9CaSu4Gy5EjiWT2s8QfhGw8ZA9iwNwx091EW+nYm02Q/fVny8ItnWHPg9W2iCxTFXJgXz0POEpKojZOP/351U8+hwO4a+4Qm/tDBpsJrizDOZyEcWvxwhr+3zk9LviQ77NPRU2UBlEQcuZeXCTENtSTav38AaOGlMx+0SBJjrvQAflG6C1Wg1b4RZSu1bQv3sLwczNYq8ilpOQDdCljYMZbfhJL98fTsAty80hYBv2Pc5sn0xZGvYNz8RgEWtCEaxiXzV/LGr5VswsQ9sQR+hLebp3aSYXhKewrVrC3J5OqRgmzaUbbP+Ies+9iTXOdi0Yl3glwEltuCTaif4BWU0krPN6yC1h41BXe1FPYyjE89CawqkPQ051Ss7iGUBqDwWN79odjAnMJa/9VQhnCmcC8tPNd7K7lR6sHGo9PPRCQ2k3Rh0VE5Pxf13307PZ7ksfCyey6lhqWhNcd1iNoo99nJdpLEt7pJOAoD/2U/rqfD69Wem9ZAHg33V5XIOqLeY6/5yaa1wnIb47Io+RArkoICZcxhDlp12/IcVIuZn6hNI67QZ09MLoQS2Q+QpPAWSTZDBViEbNwSAQ=="
    ];
  };
}
