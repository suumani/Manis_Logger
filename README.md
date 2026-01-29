-- __Manis_Logger__/README.md

# Manis Logger

Manis Logger is a lightweight **runtime logging framework** for Factorio mods.

It provides a unified way to emit logs with:
- consistent log levels
- configurable output sinks
- per-mod overrides
- clear, one-time notices when logs are suppressed by configuration

This is **not a gameplay mod**.  
It is a **developer utility** designed for debugging and inspecting complex runtime behavior.

---

## Why Manis Logger exists

Factorio already provides basic logging primitives (`log`, `game.print`, `game.write_file`).  
However, in real mod development, the following problems frequently arise:

- Logs scattered across different mods with inconsistent formats
- Debug logs silently disappearing due to configuration
- No clear indication *why* logs are not shown
- Difficulty managing logs across multiple interacting mods

Manis Logger does **not replace** Factorio’s logging system.  
It provides a **thin, explicit layer** on top of it.

---

## Key principles

- **No magic**
  - All behavior is controlled by Mod settings
  - Existing save settings are never overwritten
- **No hidden state**
  - If a log is suppressed, the reason is clearly reported (once)
- **No forced dependencies**
  - Mods can safely fall back if Manis Logger is not installed
- **Clear responsibility boundaries**
  - Manis Logger decides *when* to emit
  - Users decide *where* logs go

---

## Features

- Log levels: `debug`, `info`, `warn`, `error`
- Output sinks:
  - `factorio-current.log`
  - in-game chat
  - `script-output` file
- Runtime-global (Per-map) configuration
- Per-mod override settings via `source_key`
- One-time notices when logs are suppressed by configuration
- Remote interface API (stable contract)

---

## How mods use Manis Logger

Manis Logger is accessed via **remote interface**.

### Minimal example

```lua
if remote.interfaces["manis_logger"] then
  remote.call(
    "manis_logger",
    "debug",
    "MyMod",
    "something happened",
    game.player and game.player.index or nil,
    "mymod"
  )
else
  log("[MyMod] something happened")
end
```

 - MyMod : log tag (displayed in prefix)
 - mymod : source key (used for per-mod settings)

---

## Configuration

All settings are runtime-global (Per-map).

### Global defaults (Manis Logger)

 - manis-logger-level
 - manis-logger-to-log
 - manis-logger-to-print
 - manis-logger-to-file

These apply when no per-mod override exists.

### Per-mod overrides

Mods may define their own settings using a source_key prefix:

 - <source_key>-logger-level
 - <source_key>-logger-to-log
 - <source_key>-logger-to-print
 - <source_key>-logger-to-file

If present, these take priority over Manis Logger defaults.

---

## About suppressed debug logs

When a mod emits a debug log but the effective log level is higher (e.g. info):

 - The debug log is suppressed (by design)
 - Manis Logger emits a one-time notice explaining:
   - which source was affected
   - which level is currently active
  - how to enable debug output

This notice respects the same output sink settings as normal logs.

--- 

## What Manis Logger does not do
 - It does not modify game behavior
 - It does not change Factorio’s logging system
 - It does not auto-enable debug output
 - It does not overwrite user settings

## Intended audience
 - Factorio mod developers
 - Developers working with multiple interacting mods
 - Anyone who wants predictable, explainable runtime logging

## License

Same license as the Manis mod ecosystem
(see repository for details).