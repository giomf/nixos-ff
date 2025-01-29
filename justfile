switch host:
    nixos-rebuild switch --flake .\?submodules=1#EppdPi --target-host {{host}} --use-remote-sudo |& nom
    
switch-remote host:
    nixos-rebuild build --flake .\?submodules=1#EppdPi --build-host guif.dev |& nom
    nixos-rebuild switch --flake .\?submodules=1#EppdPi --target-host {{host}}  --use-remote-sudo
