{ lib, config, ... }:

{

  services.divera-status-tracker = {
    enable = true;
    timer = "hourly";
    config_path = config.age.secrets.divera-status-tracker-config.path;
    data_dir = /var/lib/divera-status-tracker;
  };

  age.secrets = lib.mkIf config.services.divera-status-tracker.enable {
    divera-status-tracker-config.file = ../../secrets/divera-status-tracker-config.age;
  };

  systemd.services.divera-status-tracker-init =
    lib.mkIf config.services.divera-status-tracker.enable
      {
        Description = "Init the needed data directory for Divera-Status-Tracker";
        Type = "oneshot";
        script = "mkdir -p ${config.services.divera-status-tracker.data_dir}";
        WantedBy = [ "multi-user.target" ];
      };
}
