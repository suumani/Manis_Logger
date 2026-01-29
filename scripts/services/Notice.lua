-- __Manis_Logger__/scripts/services/Notice.lua
-- ------------------------------------------------------------
-- Responsibility:
--   One-time notices about logger configuration that can cause "no output" confusion.
--   - Never modifies settings.
--   - Emits at most once per save per source_key + notice_kind.
--   - Respects user sink settings (to_log / to_print / to_file) via LogSettings.
-- ------------------------------------------------------------
local N = {}

local LogSettings = require("scripts/services/LogSettings")

local function once_key(source_key, kind)
  return tostring(source_key or "nil") .. "::" .. tostring(kind)
end

local function already_shown(key)
  storage.manis_logger_notice = storage.manis_logger_notice or {}
  if storage.manis_logger_notice[key] then return true end
  storage.manis_logger_notice[key] = true
  return false
end

local function has_setting(name)
  return settings.global[name] ~= nil
end

-- Write notice lines to sinks based on current settings.
local function write_notice(source_key, lines)
  local sinks = LogSettings.get_sinks(source_key)

  if sinks.to_log then
    for _, line in ipairs(lines) do
      log(line)
    end
  end

  if sinks.to_print and game and game.print then
    for _, line in ipairs(lines) do
      game.print(line)
    end
  end

  if sinks.to_file and game and game.write_file then
    local file = sinks.file_name or "manis_logger.log"
    for _, line in ipairs(lines) do
      game.write_file(file, line .. "\n", true)
    end
  end
end

-- Called when a DEBUG log is suppressed by level filtering.
function N.notify_debug_suppressed(source_key, effective_level_name)
  local k = once_key(source_key, "debug_suppressed")
  if already_shown(k) then return end

  local lines = {
    "[Manis_Logger] DEBUG log suppressed by logger level.",
    "[Manis_Logger] source_key=" .. tostring(source_key) .. " effective_level=" .. tostring(effective_level_name),
    "[Manis_Logger] To enable DEBUG for this source, open: Settings -> Mod settings -> Per-map",
  }

  if source_key and has_setting(source_key .. "-logger-level") then
    lines[#lines + 1] = "[Manis_Logger] and set: " .. source_key .. "-logger-level = debug"
  else
    lines[#lines + 1] = "[Manis_Logger] (Per-source level setting not found; using Manis_Logger defaults)"
    lines[#lines + 1] = "[Manis_Logger] Default key: manis-logger-level"
  end

  write_notice(source_key, lines)
end

-- Called once per source_key when per-source sink/level keys are missing.
function N.notify_source_settings_missing(source_key)
  if not source_key then return end

  local k = once_key(source_key, "source_settings_missing")
  if already_shown(k) then return end

  local lk = source_key .. "-logger-level"
  local pk = source_key .. "-logger-to-print"
  local fk = source_key .. "-logger-to-file"
  local gk = source_key .. "-logger-to-log"

  local missing_any =
    (not has_setting(lk)) or (not has_setting(gk)) or (not has_setting(pk)) or (not has_setting(fk))

  if not missing_any then return end

  local lines = {
    "[Manis_Logger] Per-source logger settings not found for source_key=" .. tostring(source_key) .. ".",
    "[Manis_Logger] Using Manis_Logger default settings instead.",
    "[Manis_Logger] Expected keys (runtime-global):",
    "  - " .. lk,
    "  - " .. gk,
    "  - " .. pk,
    "  - " .. fk,
  }

  write_notice(source_key, lines)
end

return N