# Hyprland on this Ubuntu/NixGL host

Use this note before reproducing, updating, or rolling back Hyprland on this host. It is a snapshot of the live setup checked on 2026-10-26, not a recipe to copy blindly: verify paths, package revisions, and errors on the machine before changing anything. Keep the user's Hyprland config and Nix profile intact unless the request explicitly calls for a change.

## Host constraints and current snapshot

- Ubuntu 22.04.5 LTS; account is Azure AD/SSSD-backed, with no local `/etc/passwd` row. NSS/SSSD resolves the account; use `id`/`getent passwd "$(id -u)"` and `$HOME` rather than hard-coded UIDs or local-passwd assumptions.
- Internet/Nix fetches require the local proxy `http://127.0.0.1:3128`. Check that the process doing the fetch has proxy variables or an equivalent proxy setting; don't assume the desktop session exported them.
- Intel GPU (`8086:a7a1`, kernel driver `i915`). Ubuntu Mesa package is 23.2.1; the active NixGL wrapper supplies Nix Mesa 25.0.5 and its EGL/GBM/VA library paths.
- Nix is installed as a user profile (`~/.nix-profile`), not a NixOS system configuration. Current command reports Nix 2.33.0. The active profile is generation 129 and contains many unrelated tools; inspect `nix profile history` before changing it, and avoid whole-profile rollback/upgrade when only Hyprland needs changing.
- Active Hyprland is 0.53.0 (`ea444c35bb23b6e34505ab6753e069de7801cc25`), from nixpkgs revision `16c7794d0a28b5a37904d55bcca36003b9109aaa`. The profile also has nixGL from `guibou/nixGL` revision `b6105297e6f0cd041670c3e8628394d4ee247ed5`.
- Wayle is 0.7.0 from a separate nixpkgs-weekly pin. Current `hyprctl -j workspaces` has `id` and `windows` but no `tiledLayout`; Wayle's workspace decoder requires `tiledLayout`. That is why upgrading only Wayle can make workspace occupancy disappear. Hyprland 0.54.0 is the first tagged version checked here that emits the field.
- `hyprctl configerrors` is empty. `hyprctl plugin list` says no plugins are loaded. The Nix profile contains `hyprexpo` 0.53.0 and the config has an `hyprexpo` settings block; the installed plugin package alone does not mean the plugin is loaded.
- Xwayland is currently installed and running (`Xwayland :0 ...`); Hyprland's `xwayland:enabled` option is enabled by default. This conflicts with the reported “Xwayland does not work” symptom, so test an actual X11 client before treating Xwayland startup as the current failure.

## Launch chain (the important compatibility workaround)

The selected display-manager session is `/usr/share/wayland-sessions/hyprland.desktop` (root-owned). Its `Exec` points to `$HOME/.local/bin/wrapped-hyprland`.

That wrapper currently:

1. Adds `$HOME/.nix-profile/bin` to `PATH`.
2. Appends `$HOME/.nix-profile/share` and `/nix/var/nix/profiles/default/share` to `XDG_DATA_DIRS` so Nix desktop entries/apps can be found.
3. Runs `nixGL $HOME/.nix-profile/bin/start-hyprland`.

Keep **both** `nixGL` and `start-hyprland` in this launch path. NixGL bridges the Nix-built compositor to the Ubuntu Intel/Mesa stack by setting `GBM_BACKENDS_PATH`, `LIBGL_DRIVERS_PATH`, `LIBVA_DRIVERS_PATH`, `__EGL_VENDOR_LIBRARY_FILENAMES`, and `LD_LIBRARY_PATH`. The paths it exports are Nix-store paths and change when packages change: never copy those hashes into a durable wrapper. Starting with Hyprland 0.53, upstream says to launch with `start-hyprland`, not the `Hyprland` binary directly.

There is also `/usr/share/wayland-sessions/hyprland-uwsm.desktop`, which uses `nixGL ... uwsm start ...`. It is a separate session option; don't silently switch the user's selected session to it while repairing the ordinary Hyprland entry. Both system session files are root-owned and contain this user's absolute home path, so check permissions and actual `$HOME` before recreating them.

### GLib / GLIBC distinction

The live `wrapped-hyprland` script, session entry, and Hyprland process environment do **not** currently contain `GIO_EXTRA_MODULES`, `GIO_MODULE_DIR`, or another GLib-specific override. I could not find the remembered GLib patch in the active launch path or config backups. Do not invent one: if a future startup failure suggests it is needed, capture the exact error and test the specific GIO/GLib module path against the selected Nix package first.

The environment does contain a related but different cleanup pattern: AppImage desktop entries unset Nix graphics/GIO variables, and `$HOME/.local/bin/system-gui-app` starts host GUI applications with a clean environment while selectively forwarding Wayland, XDG, cursor, proxy, and certificate settings. This prevents NixGL's library paths from contaminating Ubuntu applications. Do not confuse this with the Hyprland launcher.

Also do not confuse **GLib** with **glibc**. `$HOME/.local/bin/system-glib` selects Ubuntu's system compiler for .NET NativeAOT; the Hoppscotch wrappers use a Nix glibc loader. Those are unrelated workarounds, not part of Hyprland startup.

## User config and supporting services

- Main config: `$HOME/.config/hypr/hyprland.conf` (Hyprlang format), which sources `hyprland/env.conf`, `execs.conf`, `general.conf`, `rules.conf`, `keybinds.conf`; monitor config is `$HOME/.config/hypr/monitors.conf`.
- Keep this Hyprlang config if rollback to 0.53 is required. The 0.55 release says Hyprlang remains supported “for a few releases,” but a Lua-only config would not be a safe rollback format for 0.53.
- The startup config launches Wayle, hypridle, fcitx5, the Hyprland portal backend, clipboard watchers, and other desktop helpers. Preserve these unless the task specifically changes session behavior.
- Portal configuration prefers `hyprland;gtk`, with Hyprland selected for screencast and screenshots. User systemd units under `$HOME/.config/systemd/user/` use absolute `/nix/store/...` paths for xdg-desktop-portal 1.20.4 and xdg-desktop-portal-hyprland 1.3.11. After changing portal packages, refresh those unit paths from the active profile/package, then `systemctl --user daemon-reload` and restart the services; don't retain dead store paths.
- If updating Hyprland, rebuild/reselect any plugins for the exact compositor ABI. Current `hyprexpo` is packaged for 0.53.0, and no plugin is currently loaded.

## Upgrade/downgrade changes to check

| Version | Change relevant to this host |
| --- | --- |
| 0.53 | Launch through `start-hyprland`; the wrapper already does this. Hyprpaper 0.8 has a separate breaking config/IPC change, but this host starts `swww`, not hyprpaper. |
| 0.54 | `hyprctl` workspace JSON includes `tiledLayout` (needed by Wayle 0.7). `togglesplit` and `swapsplit` dispatchers were removed; the active config uses both. Replace the binds with `layoutmsg, togglesplit` and `layoutmsg, swapsplit`. The `single_window_aspect_ratio*` options moved from `dwindle` to `layout`, but the current config does not set them. Layouts were rewritten and can be assigned per workspace; review plugin/layout assumptions. |
| 0.55 | Lua became the default config format, but the release states existing Hyprlang configs continue working for a few releases. Keep Hyprlang for rollback compatibility. `dwindle:pseudotile` was removed as ineffective; the current `general.conf` sets `pseudotile = true`, so remove that line when running 0.55+. Other removed options (`decoration:shadow:ignore_window`, `render:cm_fs_passthrough`, `misc:vfr`) are not present in the active config. |
| 0.56 | Upstream 0.56 announcement says there are no breaking changes. The current upstream GitHub release page lists 0.56.2 as latest; prefer a tagged stable package over an untagged development build, and verify both `id` and `tiledLayout` in workspace JSON for Wayle. |

The relevant active config lines are in `$HOME/.config/hypr/hyprland/keybinds.conf` (`togglesplit`/`swapsplit`) and `$HOME/.config/hypr/hyprland/general.conf` (`dwindle:pseudotile`). Do not edit them just to document this note.

## Recovery checklist for an agent

1. Resolve the logged-in user/home using `id`, `getent`, and `$HOME`; confirm proxy availability before any Nix network operation.
2. Read the live Hyprland version, Nix profile entry/source, `wrapped-hyprland`, both session entries, and `hyprctl configerrors`. Treat Nix-store paths and profile source revisions as machine-specific snapshot data.
3. Keep the existing compositor launch chain (`nixGL` → `start-hyprland`) and host GUI environment isolation. Do not launch the Nix compositor directly to “test” GL unless doing a controlled diagnostic.
4. For Wayle 0.7 workspace occupancy, choose a tagged Hyprland build whose `hyprctl -j workspaces` objects contain both `id` and `tiledLayout`; 0.53.0 is insufficient. A version change requires the config migrations above and a plugin-ABI check.
5. Validate before calling the recovery complete: `hyprctl version`, empty `hyprctl configerrors`, `hyprctl -j workspaces | jq '.[0] | {id, tiledLayout, windows}'`, Wayle workspace occupancy, portal services, and the actual Xwayland behavior the user reports.
6. Report which workaround was reproduced, which was unnecessary, and any remaining user-only step. Do not claim the GLib patch was recreated unless a concrete active setting and successful test confirm it.

## Upstream references

- [Hyprland 0.53 announcement](https://hypr.land/news/update53/)
- [Hyprland 0.54 announcement](https://hypr.land/news/update54/)
- [Hyprland 0.55 announcement](https://hypr.land/news/update55/)
- [Hyprland 0.56 announcement](https://hypr.land/news/update56/)
- [Hyprland tagged releases](https://github.com/hyprwm/Hyprland/releases)
- [Current Hyprland wiki](https://wiki.hypr.land/)
