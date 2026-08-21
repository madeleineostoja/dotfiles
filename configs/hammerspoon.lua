local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "io.appmakes.otty",
  a = "com.openai.codex",
  x = "dev.zed.Zed",
  b = "net.imput.helium",
  w = "com.apple.Safari",
  e = "com.apple.mail",
  m = "com.apple.music",
  n = "notion.id"
}

for key, bundleID in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocusByBundleID(bundleID)
  end)
end
