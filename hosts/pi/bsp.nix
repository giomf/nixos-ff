{
  lib,
  pkgs,
  ...
}:

{
  # The kernel from the bsp is currently not in cachix so we force the kernel from nixpkgs
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi3;
  raspberry-pi-nix.board = "bcm2711";
  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pwr_led_activelow = {
        enable = true;
        value = "off";
      };
    };
  };

  # Workaround for: https://github.com/NixOS/nixpkgs/issues/154163
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
