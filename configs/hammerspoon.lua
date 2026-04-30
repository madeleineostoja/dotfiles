local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "Ghostty",
  c = "Visual Studio Code",
  b = "Helium",
  w = "Safari",
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end
