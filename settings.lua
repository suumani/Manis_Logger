-- __Manis_Logger__/settings.lua
data:extend({
  {
    type = "string-setting",
    name = "manis-logger-level",
    setting_type = "runtime-global",
    default_value = "info",
    allowed_values = { "off", "error", "warn", "info", "debug" },
    order = "z[manis-logger]-a[level]"
  },
  {
    type = "bool-setting",
    name = "manis-logger-to-log",
    setting_type = "runtime-global",
    default_value = true,
    order = "z[manis-logger]-b[to-log]"
  },
  {
    type = "bool-setting",
    name = "manis-logger-to-print",
    setting_type = "runtime-global",
    default_value = false,
    order = "z[manis-logger]-c[to-print]"
  },
  {
    type = "bool-setting",
    name = "manis-logger-to-file",
    setting_type = "runtime-global",
    default_value = false,
    order = "z[manis-logger]-d[to-file]"
  }
})