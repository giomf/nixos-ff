{ config, ... }:

{
  age.secrets.divera-reports-config.file = ../../secrets/divera-reports-config.age;
  services.divera-reports = {
    enable = true;
    timer = "hourly";
    config_path = config.age.secrets.divera-reports-config.path;  
  };
}
