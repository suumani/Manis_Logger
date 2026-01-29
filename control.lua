-- __Manis_Logger__/control.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Runtime entry for Manis_Logger.
--   - Registers remote interface "manis_logger" (Public API).
-- ------------------------------------------------------------
local Api = require("scripts/api")
Api.register_remote_interface()