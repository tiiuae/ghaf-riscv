# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  config,
  lib,
  ...
}: let
  cfg = config.ghaf.host.networking;
in
  with lib; {
    options.ghaf.host.networking = {
      enable = mkEnableOption "Host networking";
      # TODO add options to configure the network, e.g. ip addr etc
    };

    config = mkIf cfg.enable {
      networking = {
        enableIPv6 = false;
        useNetworkd = true;
      };
    };
  }
