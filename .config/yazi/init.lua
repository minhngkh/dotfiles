require("folder-rules"):setup()

local start_action = os.getenv("YAZI_START_ACTION")

if start_action == "zoxide" then
  -- os.setenv("YAZI_START_ACTION", "")
  ya.mgr_emit("plugin", { "zoxide", sync = true })

end
