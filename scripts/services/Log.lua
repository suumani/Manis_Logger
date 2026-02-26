-- __Manis_Logger__/scripts/services/Log.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Logging service with per-source level/sinks control.
--   MUST NOT crash even if caller passes non-string values.
-- ------------------------------------------------------------

local M = {}
local Settings = require("scripts/services/LogSettings")
local Notice = require("scripts/services/Notice")

local LEVEL_VALUE = { debug=10, info=20, warn=30, error=40, off=9999 }

local function to_string(v)
  if v == nil then return "nil" end
  if type(v) == "string" then return v end

  -- serpent may or may not be available depending on environment/load order.
  if serpent and serpent.line then
    return serpent.line(v, { comment = false })
  end

  return tostring(v)
end

local function prefix(tag, player_index)
  local t = (game and game.tick) or -1
  local p = player_index and (" p" .. player_index) or ""
  return "[" .. to_string(tag or "Mod") .. "][" .. t .. p .. "]"
end

local function should_emit(level_name, source_key)
  local min_name = Settings.get_level_name(source_key)
  local min_v = LEVEL_VALUE[min_name] or LEVEL_VALUE.info
  local v = LEVEL_VALUE[level_name] or LEVEL_VALUE.info
  return v >= min_v, min_name
end

local function write_sinks(sinks, line)
  if sinks.to_log then log(line) end
  if sinks.to_print and game and game.print then game.print(line) end
  if sinks.to_file and game and game.write_file then
    game.write_file(sinks.file_name or "manis_logger.log", line .. "\n", true)
  end
end

local function emit(level_name, tag, msg, player_index, source_key)
  -- 1) optional: warn once if per-source keys are missing (but source_key is provided)
  Notice.notify_source_settings_missing(source_key)

  local ok, effective_min = should_emit(level_name, source_key)

  -- 2) if DEBUG was suppressed, notify once (do not spam)
  if (not ok) and level_name == "debug" then
    Notice.notify_debug_suppressed(source_key, effective_min)
    return
  end

  if not ok then return end

  local sinks = Settings.get_sinks(source_key)
  local line = prefix(tag, player_index) .. " " .. string.upper(level_name) .. " " .. to_string(msg)
  write_sinks(sinks, line)
end

function M.debug(tag, msg, player_index, source_key) emit("debug", tag, msg, player_index, source_key) end
function M.info(tag, msg, player_index, source_key)  emit("info",  tag, msg, player_index, source_key) end
function M.warn(tag, msg, player_index, source_key)  emit("warn",  tag, msg, player_index, source_key) end
function M.error(tag, msg, player_index, source_key) emit("error", tag, msg, player_index, source_key) end

return M