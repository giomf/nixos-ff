let
  eppdpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4Vf3XnR+/Uxw4w54ewPO04OdPlP5+Hq62PBxX57NG2";
in
{
  "divera-reports-config.age".publicKeys = [ eppdpi ];
  "divera-status-tracker-config.age".publicKeys = [ eppdpi ];
  "access-point-password.age".publicKeys = [ eppdpi ];
  "divera-monitor-autologin.age".publicKeys = [ eppdpi ];
}
