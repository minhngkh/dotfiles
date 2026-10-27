local home = os.getenv("HOME") or "/home/gmi4hc"
local config_dir = home .. "/.config/hypr"
local scripts = config_dir .. "/scripts"
local bin = home .. "/.local/bin"
local terminal = bin .. "/ghostty"

-- Session environment
hl.env("HYPR_CONFIG", config_dir)
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- hyprdynamicmonitors still writes its generated profile in Hyprland's
-- monitor= syntax. Convert each generated entry to the Lua monitor API.
local function load_monitor_profile(path)
  local file = io.open(path, "r")
  if not file then
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
    return
  end

  local loaded = false
  for line in file:lines() do
    local rule = line:match("^%s*monitor%s*=%s*(.-)%s*$")
    if rule then
      local fields = {}
      for field in (rule .. ","):gmatch("(.-),") do
        fields[#fields + 1] = field
      end

      if #fields >= 4 then
        local options = {}
        for index = 5, #fields - 1, 2 do
          options[fields[index]] = fields[index + 1]
        end

        hl.monitor({
          output = fields[1],
          mode = fields[2],
          position = fields[3],
          scale = tonumber(fields[4]) or fields[4],
          transform = tonumber(options.transform) or options.transform,
          vrr = tonumber(options.vrr) or options.vrr,
        })
        loaded = true
      end
    end
  end
  file:close()

  if not loaded then
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  end
end

load_monitor_profile(config_dir .. "/monitors.generated.conf")

hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = { natural_scroll = false },
  },
  general = {
    gaps_in = 4,
    gaps_out = { 1, 8, 8, 8 },
    border_size = 2,
    col = {
      active_border = "rgb(ffffff)",
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  master = { new_status = "master" },
  -- dwindle.pseudotile was removed from Hyprland; use the Super+P dispatcher
  -- to pseudotile a window when needed.
  dwindle = { preserve_split = true },
  group = {
    col = {
      border_active = "rgb(ffffff)",
      border_inactive = "rgba(595959aa)",
    },
    groupbar = {
      render_titles = false,
      indicator_height = 5,
      col = { active = "rgb(fc9454)" },
      rounding = 3,
    },
  },
  decoration = {
    rounding = 7,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = { enabled = false },
    blur = { enabled = true, passes = 1 },
  },
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
    allow_session_lock_restore = true,
    disable_autoreload = true,
    swallow_regex = "(" .. terminal .. ")",
  },
})

hl.device({
  name = "elan0677:00-04f3:3196-touchpad",
  accel_profile = "adaptive",
  sensitivity = 0.5,
  repeat_rate = 50,
  repeat_delay = 500,
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })
hl.curve("easeInOutExpo", { type = "bezier", points = { { 0.87, 0 }, { 0.13, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "easeOutExpo", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "easeOutExpo" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "easeOutQuint", style = "fade" })

-- Window rules
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
  name = "fullscreen-1",
  match = { fullscreen_state_client = 2, fullscreen_state_internal = 0 },
  border_color = "rgb(bae6fd)",
})
hl.window_rule({
  name = "fullscreen-2",
  match = { fullscreen_state_client = 1, fullscreen_state_internal = 1 },
  border_color = "rgb(fde68a)",
})
hl.window_rule({
  name = "fullscreen-3",
  match = { fullscreen_state_client = 2, fullscreen_state_internal = 1 },
  border_color = "rgb(a7f3d0)",
})

for _, app in ipairs({
  { name = "cursor", class = "^(cursor)$" },
  { name = "vs-code", class = "^(code)$" },
  { name = "zed", class = "^(dev.zed.Zed)$" },
  { name = "ghostty", class = "^(com.mitchellh.ghostty)$" },
}) do
  hl.window_rule({ name = app.name, match = { class = app.class }, opacity = "0.95" })
end

hl.window_rule({
  name = "blueberry",
  match = { class = "^(blueberry.py)$" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "fcitx5",
  match = { class = "^(org.fcitx.fcitx5-config-qt)$" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "kde-file-manager",
  match = { class = "^(org.freedesktop.impl.portal.desktop.kde)$" },
  center = true,
  min_size = { "monitor_w*0.5", "monitor_h*0.7" },
})
hl.window_rule({
  name = "float-win",
  match = { class = "^(com.hypr.float_win)(.*)$" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "v-large",
  match = { class = "^(com.hypr.float_win_v_large)$" },
  center = true,
  size = { "monitor_w*0.3", "monitor_h*0.7" },
})
hl.window_rule({
  name = "h-large",
  match = { class = "^(com.hypr.float_win_h_large)$" },
  center = true,
  size = { "monitor_w*0.8", "monitor_h*0.9" },
})
hl.window_rule({
  name = "h-mid",
  match = { class = "^(com.hypr.float_win_h_mid)$" },
  size = { "monitor_w*0.6", "monitor_h*0.7" },
})
hl.window_rule({
  name = "pip",
  match = { title = "^(Picture(-| )[Ii]n(-| )[Pp]icture)$" },
  keep_aspect_ratio = true,
  move = { "monitor_w*0.73", "monitor_h*0.72" },
  size = { "monitor_w*0.25", "monitor_h*0.25" },
  float = true,
  pin = true,
})
hl.window_rule({
  name = "file-picker",
  match = { title = "^((Open File)|(Select a File)|(Open Folder)|(Save As)|(Library)|(File Upload))(.*)$" },
  float = true,
})
hl.window_rule({
  name = "spotify",
  match = { initial_class = "^(spotify)$" },
  float = true,
  workspace = "special:music",
  size = { "monitor_w*0.9", "monitor_h*0.9" },
  center = true,
})
hl.window_rule({
  name = "notesnook",
  match = { title = "^(Notesnook)$" },
  workspace = "special:note",
})
hl.window_rule({
  name = "scratchpad",
  match = { workspace = "special:term" },
  size = { "monitor_w*0.65", "monitor_h*0.8" },
  float = true,
  center = true,
})
hl.window_rule({
  name = "chatterino-usercard",
  match = { class = "^(com.chatterino.chatterino)$", title = "Usercard" },
  stay_focused = true,
})

-- Workspace rules
for workspace = 1, 7 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "HDMI-A-1" })
end
for workspace = 8, 10 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "eDP-1" })
end
hl.workspace_rule({ workspace = "8", layout = "scrolling" })
for workspace = 11, 12 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "DP-1" })
end

-- Replace on-created-empty workspace rules with the current Lua event API.
local special_workspace_commands = {
  ["special:term"] = terminal,
  ["special:music"] = "spotify-launcher",
  ["special:note"] = "notesnook",
}
hl.on("workspace.created", function(workspace)
  if not workspace.is_empty then
    return
  end
  local command = special_workspace_commands[workspace.name]
  if command then
    hl.exec_cmd(command, { workspace = workspace.name .. " silent" })
  end
end)

-- Native compositor actions use hl.dsp.*; use exec_cmd for external programs.
hl.bind("SUPER + B", hl.dsp.workspace.toggle_special("music"))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + E", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind("SUPER + G", hl.dsp.exec_cmd("anyrun"))
hl.bind("SUPER + SHIFT + G", hl.dsp.group.toggle())
hl.bind("SUPER + CTRL + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + CTRL + J", hl.dsp.layout("swapsplit"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exit())
hl.bind("SUPER + M", hl.dsp.window.center())
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd(scripts .. "/setup-pip-chatterino.sh"))
hl.bind("SUPER + CTRL + M", function()
  hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
  hl.dispatch(hl.dsp.window.move({ workspace = "+0", follow = false }))
  hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
  hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
  hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
end)
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("hyprshot -m region --freeze --raw | tesseract -l eng - - | wl-copy"))
hl.bind("SUPER + CTRL + O", hl.dsp.exec_cmd("hyprshot -m region --freeze --raw | tesseract - - | wl-copy"))
hl.bind("SUPER + P", hl.dsp.window.pseudo({ action = "toggle" }))
-- This dispatcher accepts percentage deltas, which the Lua resize API does not.
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -15% 0"))
hl.bind("SUPER + CTRL + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.exec_cmd(bin .. "/pypr menu"))
hl.bind("SUPER + CTRL + R", hl.dsp.exec_cmd(scripts .. "/test.sh"))
hl.bind("SUPER + SHIFT + R", function()
  hl.dispatch(hl.dsp.reload_config())
  hl.exec_cmd(bin .. "/pypr reload")
end)
hl.bind("SUPER + CTRL + SHIFT + R", hl.dsp.exec_cmd(scripts .. "/reload.sh"))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("term"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(bin .. "/pypr toggle_special term"))
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd(scripts .. "/toggle-follow-mouse.sh"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --placeholder='type to search clipboard' | cliphist decode | wl-copy"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("sh -c '" .. home .. "/.nix-profile/bin/zen'"))
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("emote"))
hl.bind("SUPER + SHIFT + PERIOD", hl.dsp.exec_cmd("cat " .. config_dir .. "/assets/emojis.txt | fuzzel --dmenu --placeholder='Type to search emojis' | cut -d ' ' -f 1 | tr -d '\\n' | wl-copy"))
hl.bind("SUPER + BRACKETLEFT", hl.dsp.group.prev())
hl.bind("SUPER + BRACKETRIGHT", hl.dsp.group.next())
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region --freeze --raw | swappy -f -"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active -f Screenshot_$(date '+%Y-%m-%d_%H.%M.%S').png"))

hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { mouse = true })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }), { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

for key, workspace in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }) do
  local symbol = key == 10 and "0" or tostring(key)
  hl.bind("SUPER + " .. symbol, hl.dsp.focus({ workspace = workspace }))
  hl.bind("SUPER + SHIFT + " .. symbol, hl.dsp.window.move({ workspace = workspace, follow = true }))
end
hl.bind("SUPER + MINUS", hl.dsp.focus({ workspace = 11 }))
hl.bind("SUPER + EQUAL", hl.dsp.focus({ workspace = 12 }))
hl.bind("SUPER + SHIFT + MINUS", hl.dsp.window.move({ workspace = 11, follow = true }))
hl.bind("SUPER + SHIFT + EQUAL", hl.dsp.window.move({ workspace = 12, follow = true }))

hl.bind("SUPER + CTRL + LEFT", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + CTRL + UP", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + CTRL + DOWN", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + CTRL + SHIFT + LEFT", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + SHIFT + UP", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind("SUPER + CTRL + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind("SUPER + CTRL + SHIFT + DOWN", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind("SUPER + SHIFT + W", hl.dsp.workspace.swap_monitors({ monitor1 = "eDP-1", monitor2 = "HDMI-A-1" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "/toggle-mute.sh"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scripts .. "/toggle-micmute.sh"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Startup programs
hl.on("hyprland.start", function()
  for _, command in ipairs({
    "swww-daemon -f xrgb &",
    "wayle panel start &",
    "fcitx5 &",
    "/usr/libexec/polkit-agent-helper-1",
    "gnome-keyring-daemon --start --components=secrets",
    "hypridle",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start --no-block xdg-desktop-portal-hyprland",
    bin .. "/pypr &",
    "wl-paste --type text --watch cliphist -max-items 20 store",
    "wl-paste --type image --watch cliphist -max-items 20 store",
    "sh -c 'dex -a -s \"$HOME/.config/autostart:/etc/xdg/autostart\"' &",
    "hyprctl setcursor Bibata-Modern-Classic 24",
    bin .. "/wrapped-hyprdynamicmonitors",
  }) do
    hl.exec_cmd(command)
  end
end)
