local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "com.mitchellh.ghostty",
  c = "com.microsoft.VSCode",
  b = "net.imput.helium",
  w = "com.apple.Safari",
  m = "com.apple.mail",
  n = "notion.id"
}

for key, bundleID in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocusByBundleID(bundleID)
  end)
end
