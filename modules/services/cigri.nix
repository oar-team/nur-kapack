{ config, lib, pkgs, ... }:


with lib;

let
  cfg = config.services.cigri;
inherit (import ./cigri-conf.nix { pkgs=pkgs; lib=lib; cfg=cfg;} ) cigriBaseConf 
in

{

  ###### interface
  
  meta.maintainers = [ maintainers.augu5te ];

  options = {
    services.cigri = {

      package = mkOption {
        type = types.package;
        default = pkgs.nur.repos.kapack.cigri;
        defaultText = "pkgs.nur.repos.kapack.cigri";
      };

      cigriHomeDir = mkOption {
        type = types.str;
        default = "/var/lib/cigri";
        description = "Home for CiGri user ";
      };

    };
  };

  ###### implementation

  config = mkIf ( cfg.user.enable ||
                  cfg.server.enable ||
                  cfg.dbserver.enable ) {

    # cigri user declaration
    users.users.oar = mkIf ( cfg.server )  {
      description = "CiGri user";
      home = cfg.cigriHomeDir;
      shell = pkgs.bashInteractive;
      uid = 746;
    };

    
    ################
    # Server Section
    systemd.services.cigri-server =  mkIf (cfg.server.enable) {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target"];
      description = "CiGri server's main process";
      restartIfChanged = false;
      #environment.OARDIR = "${cfg.package}/bin";
      serviceConfig = {
        User = "cigri";
        #Group = "root";
        ExecStart = "${cfg.package}/share/cigri/modules/almighty.rb";
        KillMode = "process";
        Restart = "on-failure";
      };
    };

    ##################
    # Database section 
    
    services.postgresql = mkIf cfg.dbserver.enable {
      #TODO TOCOMPLETE (UNSAFE)
      enable = true;
      enableTCPIP = true;
      authentication = mkForce
      ''
        # Generated file; do not edit!
        local all all              ident
        host  all all 0.0.0.0/0 md5
        host  all all ::0.0.0.0/96  md5
      '';
    };

    #networking.firewall.allowedTCPPorts = mkIf cfg.dbserver.enable [5432];
        
    systemd.services.cigridb-init = mkIf cfg.dbserver.enable {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      description = "CiGri DB initialization";
      path = [ config.services.postgresql.package ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${cfg.package}/database/init_db.rb -d cigri3 -u cigri3 -p cigri3 \
        -t psql -s ${cfg.package}/database/psql_structure.sql
      '';
    };
  };
}
