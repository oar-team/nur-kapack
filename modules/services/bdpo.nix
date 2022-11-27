{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.bdpo;

in
{
  # Interface
  meta.maintainers = [ maintainers.augu5te ];

  options = {
    services.bdpo = {
      
      enable = mkEnableOption "Bdpo initial configuration";
      
      package = mkOption {
        type = types.package;
        default = pkgs.nur.repos.kapack.bdpo;
        defaultText = "pkgs.nur.repos.kapack.bdpo";
      };
      
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Extra config to append to /etc/bdpo";
      };
    };
  };
  # Implementation
  config =  mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    boot.kernelModules = [ "msr" "acpi_cpufreq" ];

    # Allow to cgroup v1 alongside cgroup v2
    systemd.enableUnifiedCgroupHierarchy = false;
    
    systemd.services.bdpo-conf-init = {
      wantedBy = [ "network.target" ];
      before = [ "network.target" ];
      serviceConfig.Type = "oneshot";
      path = [ pkgs.util-linux ];
      script = ''
        cp ${cfg.package}/etc/bdpo.conf /etc/
        chmod 644 /etc/bdpo.conf
        mkdir /var/log/bdpo
        ${pkgs.python3.interpreter} ${cfg.package}/bin/bdpo-set-default-conf
        cat ${cfg.extraConfig} >> /etc/bdpo.conf
      '';
    };

  };
}
