local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "com.mitchellh.ghostty",
  x = "dev.zed.Zed",
  b = "net.imput.helium",
  w = "com.apple.Safari",
  e = "com.apple.mail",
  m = "com.apple.music",
  n = "notion.id",
  a = "com.anthropic.claudefordesktop"
}

for key, bundleID in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocusByBundleID(bundleID)
  end)
end
