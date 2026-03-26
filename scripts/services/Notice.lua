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

  write_notice(source_key, lines)
end

return N