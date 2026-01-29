-- __Manis_Logger__/MODPORTAL_DESCRIPTION.md

(en)
Manis Logger is a lightweight, runtime logging framework for Factorio mods.

It provides a unified logging interface with:
- Level-based filtering (debug / info / warn / error)
- Multiple output sinks (log, in-game chat, script-output file)
- Per-mod override settings
- Clear, one-time notices when logs are suppressed by configuration

This mod does NOT change Factorio’s logging behavior.
It simply offers a consistent and controlled way for mods to emit logs.

■ Features
- Unified logger API via remote interface
- Runtime-global configuration (Per-map)
- Per-mod logger settings using source keys
- Optional file output to script-output
- One-time user-friendly notices when debug logs are suppressed
- No automatic setting changes (respects user intent)

■ Intended usage
Manis Logger is designed for:
- Mod developers
- Debugging complex runtime behavior
- Large or multi-mod systems that need consistent logging

Gameplay is not affected.
This is a developer utility mod.

■ How mods use it
Mods call Manis Logger via remote interface.
If Manis Logger is not installed, mods can safely fall back to their own logging.

■ Notes
- Logging behavior is fully controlled by Mod settings
- Existing save settings are never overwritten
- Notifications follow the same output rules as normal logs

This mod is part of the Manis mod ecosystem,
but can be used independently by any mod developer.

------

(ja)
Manis Logger は、Factorio Mod 開発者向けの軽量なランタイムログ基盤です。

以下の機能を提供します：
- ログレベル制御（debug / info / warn / error）
- 出力先の統一管理（log / ゲーム内チャット / script-output）
- Mod単位でのログ設定上書き
- 設定によってログが出ない場合の分かりやすい通知

本Modは Factorio 標準のログ挙動を変更しません。
あくまで「統一されたログ出力手段」を提供するユーティリティです。

■ 主な機能
- remote interface による共通 Logger API
- Per-map（runtime-global）設定
- Modごとのログレベル・出力先設定
- script-output への任意ファイル出力
- debugログ抑制時の一度きり通知
- 設定値の自動変更は一切行わない安全設計

■ 想定用途
Manis Logger は以下を目的としています：
- Mod開発者向けデバッグ
- 複雑なランタイム挙動の可視化
- 複数Modをまたぐ一貫したログ管理

ゲームプレイ要素は一切ありません。
開発・調査用のユーティリティModです。

■ Modからの利用方法
Modは remote interface を通じて Manis Logger を呼び出します。
Manis Logger が未導入の場合でも、安全にフォールバック可能です。

■ 補足
- ログの出力挙動はすべて Mod設定で制御されます
- 既存セーブの設定は決して書き換えません
- 通知も通常ログと同じ出力ルールに従います

Manis Logger は Manis 系Modの一部として開発されていますが、
他のMod開発者も自由に利用できます。