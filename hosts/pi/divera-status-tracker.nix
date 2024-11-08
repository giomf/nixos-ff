{ lib, config, ... }:

{

  services.divera-status-tracker = {
    enable = false;
    timer = "hourly";
    config_path = config.age.secrets.divera-status-tracker-config.path;
    data_dir = "/var/lib/divera-status-tracker";
  };

  age.secrets = lib.mkIf config.services.divera-status-tracker.enable {
    divera-status-tracker-config.file = ../../secrets/divera-status-tracker-config.age;
  };

  system.activationScripts.createDiveraDataDir = lib.mkIf config.services.divera-status-tracker.enable ''
    mkdir -p ${config.services.divera-status-tracker.data_dir}
    echo "Divera Status Tracker data directory created!"
  '';
}
