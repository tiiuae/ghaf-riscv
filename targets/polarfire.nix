# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# Polarfire Enablement Kit

{
  self,
  lib,
  nixpkgs,
  nixos-hardware,
}: let
  name = "mpfs-icicle-kit";
  system = "riscv64-linux";

  mpfs-icicle-kit = variant: extraModules: let
    hostConfiguration = lib.nixosSystem {
      inherit system;
      specialArgs = {inherit lib;};
      modules =
        [
          nixos-hardware.nixosModules.polarfire-hardenedos
          ../modules/hardware/polarfire/mpfs-nixos-sdimage.nix
          (import ../modules/embedded-host {
            inherit self;
          })
          #../modules/virtualization/docker.nix

          {
            # Disable all the default UI applications
            ghaf = {
              profiles = {
                applications.enable = false;
                graphics.enable = false;
                #TODO clean this up when the microvm is updated to latest
                release.enable = variant == "release";
                debug.enable = variant == "debug";
              };
              development = {
                debug.tools.enable = variant == "debug";
                ssh.daemon.enable = true;
              };
              windows-launcher.enable = false;
              virtualization.docker.daemon.enable = false;
            };
            nixpkgs = {
              localSystem.config = "x86_64-unknown-linux-gnu";
              crossSystem.config = "riscv64-unknown-linux-gnu";
            };
            boot.kernelParams = [ "root=/dev/mmcblk0p2" "rootdelay=5"  ];
          }
        ]
        ++ (import ../modules/module-list.nix)
        ++ extraModules;


    };
  in {
    inherit hostConfiguration;
    name = "${name}-${variant}";
    package = hostConfiguration.config.system.build.sdImage;
  };
  debugModules = [];
  targets = [
    (mpfs-icicle-kit "debug" debugModules)
    (mpfs-icicle-kit "release" [])
  ];
in {
  nixosConfigurations =
    builtins.listToAttrs (map (t: lib.nameValuePair t.name t.hostConfiguration) targets);
  packages = {
    riscv64-linux =
      builtins.listToAttrs (map (t: lib.nameValuePair t.name t.package) targets);
  };
}

