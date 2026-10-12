local hyper = { "cmd", "ctrl", "alt", "shift" }

local apps = {
  t = "io.appmakes.otty",
  a = "com.apple.Safari.WebApp.56D26895-5BD7-45A2-9BD9-F9138E0DE561",
  x = "dev.zed.Zed",
  b = "net.imput.helium",
  w = "com.apple.Safari",
  e = "com.apple.mail",
  m = "com.apple.music",
  n = "notion.id",
  d = "com.todoist.mac.Todoist"
}

for key, bundleID in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocusByBundleID(bundleID)
  end)
end
