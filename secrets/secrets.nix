let
  eppdpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjEKpYYND9htelGOXBT0fyVgRXC5um2ONdyL1Oj80JJ";
in
{
  "divera-reports-config.age".publicKeys = [ eppdpi ];
  "divera-status-tracker-config.age".publicKeys = [ eppdpi ];
  "access-point-password.age".publicKeys = [ eppdpi ];
  "divera-monitor-autologin.age".publicKeys = [ eppdpi ];
}
