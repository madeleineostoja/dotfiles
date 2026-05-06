local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "Ghostty",
  c = "Visual Studio Code",
  b = "Helium",
  w = "Safari",
  m = "Mail",
  n = "Notion"
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    local running = hs.application.find(app)
    if running then
      hs.application.launchOrFocusByBundleID(running:bundleID())
    else
      hs.application.launchOrFocus(app)
    end
  end)
end
