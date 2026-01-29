-- __Manis_Logger__/README.ja.md

# Manis Logger

Manis Logger は、Factorio Mod 向けの軽量な **ランタイムログ基盤**です。

以下の特長を持つ、統一されたログ出力手段を提供します。

- 一貫したログレベル管理
- 出力先（sink）の柔軟な制御
- Mod 単位での設定上書き
- 設定によってログが出ない場合の、分かりやすい一度きりの通知

本 Mod は **ゲームプレイ要素を含みません**。  
複雑なランタイム挙動を調査・検証するための **開発者向けユーティリティ**です。

---

## Why Manis Logger exists（なぜ Manis Logger が必要か）

Factorio には、標準で以下のログ出力手段が用意されています。

- `log`
- `game.print`
- `game.write_file`

しかし、実際の Mod 開発では次のような問題が頻繁に発生します。

- Mod ごとにログ形式がばらばらになる
- 設定によって debug ログが黙って消える
- なぜログが表示されないのか分からない
- 複数 Mod が絡む挙動の調査が困難

Manis Logger は、  
**Factorio のログ機構を置き換えるものではありません**。

既存の仕組みの上に、  
**明示的で薄い制御レイヤ**を追加することを目的としています。

---

## Key principles（設計原則）

- **No magic**
  - すべての挙動は Mod 設定で制御されます
  - 既存セーブの設定を勝手に書き換えません
- **No hidden state**
  - ログが抑制された場合、その理由を明示します（1回のみ）
- **No forced dependencies**
  - Manis Logger が未導入でも Mod は安全にフォールバック可能
- **Clear responsibility boundaries**
  - Manis Logger は「いつ出すか」を決める
  - ユーザは「どこに出すか」を決める

---

## Features（機能）

- ログレベル：`debug`, `info`, `warn`, `error`
- 出力先（sink）：
  - `factorio-current.log`
  - ゲーム内チャット
  - `script-output` ファイル
- runtime-global（Per-map）設定
- `source_key` による Mod 単位の設定上書き
- debug ログ抑制時の一度きり通知
- remote interface による安定した API

---

## How mods use Manis Logger（Mod からの利用方法）

Manis Logger は **remote interface** 経由で利用します。

### Minimal example（最小例）

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

 - MyMod : ログの表示タグ（プレフィックス）
 - mymod : source key（Mod 単位設定に使用）

## Configuration（設定）

すべての設定は runtime-global（Per-map） です。

### Global defaults（Manis Logger 側のデフォルト）

 - manis-logger-level
 - manis-logger-to-log
 - manis-logger-to-print
 - manis-logger-to-file

Mod ごとの上書き設定が存在しない場合、これらが適用されます。

### Per-mod overrides（Mod 単位の上書き）

Mod は source_key を接頭辞として、独自の設定を定義できます。
 - <source_key>-logger-level
 - <source_key>-logger-to-log
 - <source_key>-logger-to-print
 - <source_key>-logger-to-file

これらが存在する場合、Manis Logger のデフォルトより優先されます。

----

## About suppressed debug logs（debug ログが抑制された場合）

Mod が debug ログを出力しても、
有効なログレベルがそれより高い場合（例：info）：

 - debug ログは 仕様として抑制されます
 - Manis Logger は 一度だけ通知を出します：
   - どの source が影響を受けたか
   - 現在有効なログレベル
   - debug を有効にする方法

この通知も、通常ログと 同じ出力先設定に従います。

---

## What Manis Logger does not do（しないこと）

 - ゲーム挙動を変更しません
 - Factorio の標準ログ機構を変更しません
 - debug 出力を自動で有効化しません
 - ユーザ設定を上書きしません

## Intended audience（対象）
 - Factorio Mod 開発者
 - 複数 Mod が絡むシステムを扱う開発者
 - 挙動が説明可能なログを求めるすべての人

## License（ライセンス）

Manis Mod エコシステムと同一のライセンスです。
詳細はリポジトリを参照してください。