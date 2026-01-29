-- __Manis_Logger__/scripts/api.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Public API surface for other mods via remote interface.
--   - Exposes debug/info/warn/error as the stable contract.
--   - (Debug helper) config(): returns effective settings for a given source_key.
-- Notes:
--   - Do NOT expose internal module paths as public contract.
-- ------------------------------------------------------------
local A = {}

local Log = require("scripts/services/Log")
local Settings = require("scripts/services/LogSettings")

function A.register_remote_interface()
  remote.add_interface("manis_logger", {
    debug = function(tag, msg, player_index, source_key)
      Log.debug(tag, msg, player_index, source_key)
    end,
    info = function(tag, msg, player_index, source_key)
      Log.info(tag, msg, player_index, source_key)
    end,
    warn = function(tag, msg, player_index, source_key)
      Log.warn(tag, msg, player_index, source_key)
    end,
    error = function(tag, msg, player_index, source_key)
      Log.error(tag, msg, player_index, source_key)
    end,

    -- debug helper
    config = function(source_key)
      return {
        level = Settings.get_level_name(source_key),
        sinks = Settings.get_sinks(source_key),
      }
    end,
  })
end

return A