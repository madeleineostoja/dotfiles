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
    hs.application.launchOrFocus(app)
  end)
end
