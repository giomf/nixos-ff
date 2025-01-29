{ lib, config, ... }:

{
  services.divera-reports = {
    enable = true;
    timer = "hourly";
    config_path = config.age.secrets.divera-reports-config.path;
  };
  age.secrets = lib.mkIf config.services.divera-reports.enable {
    divera-reports-config.file = ../../../secrets/divera-reports-config.age;
  };
}
