{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.ear;
  pgSuperUser = config.services.postgresql.superUser;
  inherit (import ./ear-conf.nix { pkgs=pkgs; lib=lib; cfg=cfg;} ) earBaseConf;
in
{
###### interface
  
  meta.maintainers = [ maintainers.augu5te ];

  options = {
  services.ear = {
     package = mkOption {
        type = types.package;
        default = pkgs.nur.repos.kapack.ear;
        defaultText = "pkgs.nur.repos.kapack.ear";
      };

         database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Host of the postgresql server. 
          '';
        };

        passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/oar-dbpassword";
        description = ''
          A file containing the usernames/passwords for database, content example:
          DBUser=ear_daemon
          DBPassw=password
          # User and password for usermode querys.
          DBCommandsUser=ear_commands
          DBCommandsPassw=password
        '';
        };
        
        dbname = mkOption {
          type = types.str;
          default = "ear";
          description = "Name of the postgresql database";
        };
      };
       
      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          EARGMEnergyLimit = 550000;
        };
        description = ''
          Extra configuration options that will replace default.
        '';
      };
      node_manager = {
        enable = mkEnableOption "EAR Node Manager (EARD)";
      };

      global_manager = {
        enable = mkEnableOption "EAR Global Manager (EARGM)";
      };
      
      db_manager = {
        enable = mkEnableOption "EAR Database Manager (EARDBD)";
      };
    };
  };
  ###### implementation!!
  config =  mkIf ( cfg.node_manager.enable ||
                   cfg.global_manager.enable ||
                   cfg.db_manager.enable ) {
    
    environment.etc."ear/ear-base.conf" = { mode = "0600"; source = earBaseConf; };

      
    environment.systemPackages =  [ pkgs.nur.repos.kapack.ear ];
    environment.variables.POY = "/etc";
    environment.variables.EAR_ETC = "/etc";
    environment.variables.EAR_TMP = "/var/lib/ear";
    
      
    security.wrappers = { }; #TODO
    
    systemd.services.ear-conf-init = {
      wantedBy = [ "network.target" ];
      before = [ "network.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        touch /etc/ear/ear.conf

        cat ${cfg.database.passwordFile} >> /etc/ear/ear.conf
        cat /etc/ear/ear-base.conf >> /etc/ear/ear.conf
      '';
    };
    ##################
    # Database Manager section



    
    environment.etc."ear/ear-db.sql" =  mkIf cfg.db_manager.enable { mode = "0666"; source = ./ear-db.sql; }; 
    services.postgresql = mkIf cfg.db_manager.enable {
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


    systemd.services.eardb-init = mkIf cfg.db_manager.enable {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      description = "EAR DB Manager initialization";
      path = [ config.services.postgresql.package ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      
      script = ''
        source ${cfg.database.passwordFile}
        mkdir -p /var/lib/ear
        if [ ! -f /var/lib/ear/db-created ]; then
          echo "Create EAR DB role $DBUser"
          echo ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create role $DBUser with login password '$DBPassw'"
          ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create role $DBUser with login password '$DBPassw'"
          echo "Create EAR DB"
          ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create database ${cfg.database.dbname} with owner $DBUser"

          echo "Create EAR DBCommandsUser role"
          ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create role $DBCommandsUser with login password '$DBCommandsPassw'"

          echo "Create EAR DB tables"
          PGPASSWORD=$DBPassw ${pkgs.postgresql}/bin/psql -U $DBUser \
            -f /etc/ear/ear-db.sql \
            -h localhost ${cfg.database.dbname}

          PGPASSWORD=$DBPassw ${pkgs.postgresql}/bin/psql -U $DBUser \
            -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $DBCommandsUser" \
            -h localhost ${cfg.database.dbname}
            
            touch /var/lib/ear/db-created
        fi
        '';
    };

    systemd.services.eardbd =  mkIf (cfg.db_manager.enable) {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target"];
      description = "EARDBD - Energy Aware Runtime database cache daemon";
      restartIfChanged = false;
      environment.EAR_ETC = "/etc";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/ear";
        KillMode = "process";
        Restart = "on-failure";
      };
    };  
    
  };
}
