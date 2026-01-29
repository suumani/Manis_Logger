-- __Manis_Logger__/scripts/services/LogSettings.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Read runtime-global settings for Manis_Logger.
--   - Supports per-source overrides via source_key:
--       <source_key>-logger-level
--       <source_key>-logger-to-log
--       <source_key>-logger-to-print
--       <source_key>-logger-to-file
--   - Falls back to Manis_Logger defaults:
--       manis-logger-level
--       manis-logger-to-log
--       manis-logger-to-print
--       manis-logger-to-file
--
-- Notes:
--   - Never writes/changes settings.
--   - Normalizes level values defensively.
-- ------------------------------------------------------------
local S = {}

local function get_setting(name)
  if not name or name == "" then return nil end
  if not settings or not settings.global then return nil end
  local s = settings.global[name]
  return s and s.value or nil
end

local function pick_string(primary, fallback, default)
  local v = get_setting(primary)
  if v ~= nil then return v end
  v = get_setting(fallback)
  if v ~= nil then return v end
  return default
end

local function pick_bool(primary, fallback, default)
  local v = get_setting(primary)
  if v ~= nil then return v end
  v = get_setting(fallback)
  if v ~= nil then return v end
  return default
end

local function k(source_key, suffix)
  if not source_key or source_key == "" then return nil end
  return source_key .. suffix
end

local function normalize_level(v)
  if type(v) ~= "string" then return nil end
  v = string.lower(v)
  v = string.gsub(v, "%s+", "")
  if v == "off" or v == "error" or v == "warn" or v == "info" or v == "debug" then
    return v
  end
  return nil
end

function S.get_level_name(source_key)
  local raw = pick_string(
    k(source_key, "-logger-level"),
    "manis-logger-level",
    "info"
  )
  return normalize_level(raw) or "info"
end

function S.get_sinks(source_key)
  return {
    to_log = pick_bool(
      k(source_key, "-logger-to-log"),
      "manis-logger-to-log",
      true
    ),
    to_print = pick_bool(
      k(source_key, "-logger-to-print"),
      "manis-logger-to-print",
      false
    ),
    to_file = pick_bool(
      k(source_key, "-logger-to-file"),
      "manis-logger-to-file",
      false
    ),
    file_name = "manis_logger.log"
  }
end

return S