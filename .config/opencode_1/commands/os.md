---
description: Context about current os
---

<context>
- This machine is a coperate machine that is azure ad joined and logged in with sssd (no entry in /etc/passwd)
- This machine is behind a local proxy to access internet, located in `http://127.0.0.1:3128`
- The os is the old ubuntu 22.04 with the windows manager being hyprland installed via NixOS with `nix profile add 'nixpkgs#hyprland'` because of its bleeding edge nature. To start the hyprland, it have to bridged using nixGL
- xwayland currently doesnt work, wayland only
</context>

$ARGUMENTS
