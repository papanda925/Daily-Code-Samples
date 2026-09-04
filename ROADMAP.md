# Daily Code Samples — Roadmap #042〜#300

現在の **#001〜#041 は実装済み**です。  
この文書は、今後1本ずつ短いサンプルへ育てる **#042〜#300 の実装候補バックログ（259件）**です。

> 目標は「コードを覚える」だけではなく、**PC・Office・Windowsの仕組みを、自分の目で見て、操作して、前後差をトレースしながら理解すること**です。

## 共通方針

- 1サンプル = 1概念。5〜30分程度で試せる大きさを基本とする
- GUIで見られるものは、まずGUIで現在状態を確認する
- 次にVBA / PowerShellで同じ状態を取得・操作する
- 操作前 → 操作 → 操作後をログや表で比較する
- 「今回触った技術の層」を最後に示す
- Visual Studioを前提にせず、可能な範囲でWindows / Office標準機能を使う
- Security / Network系は、自分のPC・自分のデータ・自分のネットワーク・ローカル実験を基本とする
- 実環境の認証情報や秘密情報を教材へ入れない
- 全銀フォーマット等は、実データではなく**教育用のダミー／全銀風固定長データ**を基本とする
- 未実装アイデアは `samples/` へ置かず、完成してから公開サンプルへ昇格する

## 学び方

```text
今の状態を見る
      ↓
1つだけ操作する
      ↓
もう一度状態を見る
      ↓
差分・ログを見る
      ↓
裏で使われている技術を知る
      ↓
昔の仕組みと現在のAPIをつなげる
```


---

## 🧩 OS Fundamentals Lab

プロセス、スレッド、イベント、ハンドル、メモリ、IPCなど、OSの基礎概念を短い実験で体験する。

- **#042** ウィンドウには番号がある？ HWNDを実際に見る
- **#043** ウィンドウを動かして座標の変化をGetWindowRectで見る
- **#044** WM_CLOSEと強制終了は何が違う？
- **#045** WindowsのMessage Loopを小さなGUIで体験する
- **#046** UIスレッドを重い処理で止めると画面はなぜ固まる？
- **#047** VBAのDoEventsでWindows Messageが処理される様子を見る
- **#048** DoEvents中に同じボタンを押して再入問題を起こしてみる
- **#049** Process ID（PID）は何のためにある？
- **#050** 1つのプロセスに複数Threadがあることを観察する
- **#051** 逐次実行と並列実行を時間で比べる
- **#052** Concurrency・Parallelism・Asyncの違いを実験で比べる
- **#053** 共有カウンターでRace Conditionを起こしてみる
- **#054** Mutexで2つのPowerShellを順番に動かす
- **#055** Semaphoreで同時実行数を2つに制限する
- **#056** Event Wait Handleで「合図が来るまで待つ」を体験する
- **#057** Timerもイベント？ 1秒ごとのTickを記録する
- **#058** プロセス終了イベントを監視してみる
- **#059** ファイルを開くとHandleが使われることを確認する
- **#060** File Lockをかけたまま別プロセスから開いてみる
- **#061** Named Pipeで2つのPowerShellを会話させる
- **#062** Named PipeとTCP Socketの違いを同じ文字列送信で比べる
- **#063** 環境変数PATH・TEMPはどこから見える？
- **#064** Registryを読み取り専用で観察する
- **#065** Windows ServiceのRunning・Stoppedを一覧で見る
- **#066** Windows Event Logから自分の操作に近いイベントを探す
- **#067** Physical MemoryとVirtual Memoryの違いを数字で見る
- **#068** Working Setはアプリのメモリ量と同じなのか？
- **#069** .NETのGarbage Collection前後でメモリ表示を比べる
- **#070** Process Priorityを観察してOSの優先度という考え方を知る
- **#071** CPU負荷をかけてOS Schedulerの仕事を観察する
- **#072** 親Processと子Processの関係をツリーで見る
- **#073** 標準入力・標準出力・標準エラーをリダイレクトしてみる
- **#074** Exit Code 0と1を自作スクリプトで体験する
- **#075** Current DirectoryとScript Directoryの違いを確認する
- **#076** Foreground Windowが切り替わるたびにHWNDとタイトルを見る

---

## 🖥 Windows & Device Trace Lab

USB、Bluetooth、画面、音声、電源など、PCが認識しているデバイスや状態を「前後差」で見る。

- **#077** USBデバイスを一覧表示して何がつながっているか見る
- **#078** USBを抜き差ししてDevice一覧の差分を取る
- **#079** USBメモリを挿すとDrive情報がどう増えるか見る
- **#080** PnP DeviceのStatusを一覧で確認する
- **#081** Device Instance IDって何？ 実物を見てみる
- **#082** BluetoothデバイスをWindowsから列挙する
- **#083** BluetoothのPairedとConnectedの違いを見る
- **#084** BLE Advertisementを自分の周囲で観察する入門
- **#085** バッテリー残量・充電状態をリアルタイム表示する
- **#086** ACアダプターを抜き差ししてPower状態の差分を見る
- **#087** CPU使用率を1秒ごとに表示して負荷の変化を見る
- **#088** メモリ使用量をアプリ起動前後で比較する
- **#089** Disk I/Oの読み書き量を処理前後で観察する
- **#090** ネットワークアダプターごとの送受信バイトを追跡する
- **#091** ディスプレイの解像度をPowerShellから取得する
- **#092** マルチディスプレイの座標と負の座標を見てみる
- **#093** DPIと拡大率150%で座標がどう見えるか確認する
- **#094** マウスカーソルのX・Y座標をリアルタイム表示する
- **#095** アクティブウィンドウのタイトルと位置を追跡する
- **#096** 自作GUIのKeyDown・KeyUpイベントだけをトレースする
- **#097** 自作GUIのMouseDown・MouseUp・Clickの順序を見る
- **#098** Clipboardに入っているデータ形式を調べる
- **#099** 現在の音声出力デバイスを確認する
- **#100** 音声出力先を切り替えてデバイス情報の差分を見る
- **#101** カメラデバイスがWindowsからどう見えているか確認する
- **#102** マイクデバイスの存在と状態だけを確認する
- **#103** プリンター一覧とDefault Printerを確認する
- **#104** Power Planの現在状態を読み取る
- **#105** PCの起動時間とUptimeを表示する
- **#106** 画面の一部をキャプチャして座標とピクセルの関係を見る

---

## 📡 Network & Wireless Lab

Wi-Fi、TCP/IP、DNS、ルーティングなどを、自分のPCと自分のネットワークを対象に観察する。

- **#107** Wi-FiのSSID・BSSID・Channelを同時に見る
- **#108** Wi-Fi信号強度をリアルタイムの棒グラフで表示する
- **#109** 2.4GHz・5GHz・6GHzの接続情報を比べる
- **#110** 周囲のWi-Fi Channelを一覧にして混雑を可視化する
- **#111** 同じSSIDでBSSIDが変わるローミングを記録する
- **#112** WindowsにあるNetwork Adapterを全部並べる
- **#113** Link Speedは実効速度と同じ？ まず値を確認する
- **#114** IPv4アドレスとIPv6アドレスを並べて見る
- **#115** Route Tableを読んでパケットの行き先を考える
- **#116** Default Gatewayは何をしている？ 設定値から確認する
- **#117** ARP／Neighbor Cacheを見て同一LANの相手を理解する
- **#118** DNS名前解決で名前がIPアドレスになる流れを見る
- **#119** DNS Cacheを名前解決の前後で比較する
- **#120** DHCPでもらったIP・Gateway・DNS情報を確認する
- **#121** localhostへPingしてLoopbackを体験する
- **#122** 自分で用意したホストへTracerouteして経路を見る
- **#123** TCP接続のESTABLISHED・LISTENなどの状態を見る
- **#124** 自分のPCでListening Portを一覧表示する
- **#125** PowerShellだけでlocalhost簡易HTTPサーバーを動かす
- **#126** TCPとUDPで同じ文字列を送って違いを見る
- **#127** localhostでHTTPとHTTPSの通信手順の違いを追う
- **#128** 127.0.0.1とlocalhostと::1の違いを試す
- **#129** 保存済みWi-Fi Profileの名前だけを一覧にする
- **#130** MTUを変えずにサイズ違いPingで断片化の概念を学ぶ
- **#131** Latency・Packet Loss・Jitterを自分の通信で記録する

---

## 🔐 Visual Security Lab

攻撃ではなく、自分のテストデータとローカル環境で「違いが目で見える」セキュリティ実験を行う。

- **#132** 1文字変えるとSHA-256はどれだけ変わる？ Avalanche Effectを見る
- **#133** Base64は暗号化ではないことをEncode→Decodeで確認する
- **#134** AESで暗号化してから復号して元に戻ることを確かめる
- **#135** HMACで1文字の改ざんを検知してみる
- **#136** 電子署名した文書を1文字変えて検証NGにしてみる
- **#137** 同じパスワードでもSaltを変えるとHashが変わることを見る
- **#138** PBKDF2の反復回数を増やすと処理時間がどう変わる？
- **#139** 乱数と単純な連番を並べて予測しやすさを考える
- **#140** ランダムなバイト列をヒストグラムで眺める
- **#141** HTTPSサイトのTLS証明書をPowerShellで見る
- **#142** Root CA→Intermediate CA→Server Certificateの鎖をたどる
- **#143** 証明書の有効期限を一覧にして期限切れを理解する
- **#144** localhostでHTTPとHTTPSの見える情報の違いを比べる
- **#145** ダウンロード前後のファイルHashで完全性を確認する
- **#146** AllowlistとDenylistを小さな文字列判定で比べる
- **#147** 管理者権限と標準ユーザー権限の違いを状態表示で見る
- **#148** NTFSアクセス権を読み取り専用で一覧表示する
- **#149** フォルダーの権限継承を親子で見比べる
- **#150** Windows FirewallのProfile状態とRule件数を確認する
- **#151** Microsoft Defenderの基本状態を読み取り専用で確認する
- **#152** ダウンロードファイルのMark of the Webを自分のファイルで見る
- **#153** Alternate Data Streamに小さなテスト文字列を保存して仕組みを知る
- **#154** PowerShellでAuthenticode署名の有無を確認する
- **#155** DPAPIで自分のテスト文字列を暗号化・復号する
- **#156** パスワード長で組み合わせ数がどう増えるか可視化する
- **#157** 固定時間比較と普通の文字列比較の考え方を小さく試す
- **#158** CSVの先頭記号が表計算で式扱いされる例を安全な文字列で確認する
- **#159** 入力値をそのまま使う場合と検証する場合の差をローカル実験する
- **#160** ログに秘密情報を書かないRedactionを実装して比べる
- **#161** 環境変数へ秘密情報を置くとプロセスからどう見えるかを自分のテスト値で確認する

---

## 🧠 Architecture & Algorithm Lab

有名な設計・分散システム・アルゴリズムを、小さな模型としてVBAやPowerShellだけで再実装する。

- **#162** PowerShellでミニBlockchainを作る
- **#163** Excel VBAでセルが変わると壊れるBlockchainを可視化する
- **#164** Merkle Treeを4つのファイルHashから作る
- **#165** Bloom Filterで「たぶんある／絶対ない」を体験する
- **#166** LRU Cacheで最近使っていないデータが追い出される様子を見る
- **#167** Token BucketでAPI Rate Limitを再現する
- **#168** RetryとExponential Backoffを失敗するローカル処理で試す
- **#169** Circuit BreakerのCLOSED・OPEN・HALF-OPENを色で見る
- **#170** フォルダーをMessage QueueにしてProducer／Consumerを作る
- **#171** VBAのEventでPub/Subを再現する
- **#172** ExcelでEvent Sourcingを実装して現在状態を再構築する
- **#173** VBAでCQRS風にWrite ModelとRead Modelを分ける
- **#174** 申請フローをState Machineとして実装する
- **#175** PowerShell RunspaceでActor Model風のMailboxを作る
- **#176** DAGで依存関係のあるJobを順番・並列に実行する
- **#177** Producer-Consumer PatternをQueueで体験する
- **#178** Observer PatternをVBAのWithEventsで実装する
- **#179** Strategy Patternで処理方法を差し替える
- **#180** Factory Patternで作るオブジェクトを切り替える
- **#181** Repository PatternでExcelセルへの直接アクセスを隠す
- **#182** Dependency Injectionで本番処理とMockを差し替える
- **#183** Command Patternで操作をオブジェクトとして記録する
- **#184** Adapter Patternで異なるAPIの呼び方を同じ形にそろえる
- **#185** Decorator Patternでログ機能を後付けする
- **#186** Cache-Aside Patternを小さな辞書とファイルで再現する
- **#187** 同じ要求を2回送っても結果が増えないIdempotencyを体験する
- **#188** Saga Patternを3段階の処理と補償処理で模型化する
- **#189** Outbox PatternをCSV／JSONファイルで再現する
- **#190** Consistent Hashingでデータの割り当て先がどう変わるか見る
- **#191** Fixed WindowとSliding WindowのRate Limitを比べる

---

## 🟣 VBA Deep Dive

VBAを単なるマクロとしてではなく、非同期・イベント・設計パターン・API連携まで掘り下げる。

- **#192** VBAで本当の非同期HTTPを実装する
- **#193** DoEventsは非同期処理ではないことをログで確認する
- **#194** WithEventsでHTTP完了イベントを受け取る
- **#195** Implementsを使ってVBAでInterfaceを作る
- **#196** VBAでDependency Injectionを実装する
- **#197** VBAでStrategy Patternを実装する
- **#198** VBAでFactory Patternを実装する
- **#199** VBAでObserver Patternを実装する
- **#200** VBAでRepository Patternを実装する
- **#201** VBAでState Machineを実装する
- **#202** VBAでPromise風AsyncTaskクラスを作る
- **#203** VBAでキャンセル可能な長時間処理を作る
- **#204** VBAの非同期処理へTimeoutを追加する
- **#205** VBAでRetry処理を共通化する
- **#206** VBAでExponential Backoffを実装する
- **#207** VBAで簡易Event Queueを作る
- **#208** CollectionとClassでDomain Object一覧を扱う
- **#209** Property Get／Let／Setでカプセル化を体験する
- **#210** On Errorだけに頼らないエラー伝播の設計を試す
- **#211** VBAで共通Loggerクラスを作る
- **#212** VBAだけで小さなJSON Serializerを作って構造を理解する
- **#213** Application.OnTimeで擬似的な非同期スケジュールを作る
- **#214** AddressOfとCallbackの制約をWin32 APIで体験する
- **#215** Early BindingとLate Bindingの違いを同じCOM操作で比べる
- **#216** 32bit／64bit VBAとPtrSafe・LongPtrの違いを学ぶ

---

## 🪟 PowerShell / WinRT / .NET Lab

Visual Studioを使わず、WindowsにあるAPIや.NETをPowerShellから直接触る。

- **#217** PowerShell + WinRTでWindowsに文章を読み上げさせる
- **#218** PowerShell + WinRTでWindows標準の音声認識を試す
- **#219** PowerShell + WinRTで画像OCRを試す
- **#220** WinRTのIAsyncOperationをPowerShellから待つ
- **#221** PowerShellからWindows通知を表示する
- **#222** WinRT DeviceInformationでデバイスを列挙する
- **#223** PowerShellからWinRT Bluetooth APIを触る
- **#224** PowerShellからClipboard APIを操作する
- **#225** PowerShellだけでWPFの小さなGUIを作る
- **#226** PowerShellだけでWindows Formsの小さなGUIを作る
- **#227** RunspaceでUIを固めずバックグラウンド処理する
- **#228** .NET TaskをPowerShellから作って待つ
- **#229** ForEach-Object -Parallelで並列処理を体験する
- **#230** PowerShellから.NET Classを直接newして使う
- **#231** Add-TypeでUser32.dllのWin32 APIを呼ぶ
- **#232** PowerShellからCOM経由でExcelを操作する
- **#233** CIMとWMIは何が違う？ 同じPC情報を取得して比べる
- **#234** FileSystemWatcherでフォルダー変更イベントを監視する
- **#235** HttpClientで同期風処理と非同期処理を比べる
- **#236** Visual StudioなしでWindows App SDK／WinUI 3の最小構成を理解する

---

## 📜 Legacy Data & File Format Lab

固定長、文字コード、ヘッダー・明細・トレーラーなど、昔から使われるデータ交換の考え方を現代の環境で体験する。

- **#237** VBAで固定長ファイルを1レコードずつ分解する
- **#238** PowerShellで固定長ファイルをSubstringで分解する
- **#239** 固定長ファイルをCSVへ変換する
- **#240** CSVから固定長ファイルを生成する
- **#241** Header・Detail・Trailerレコードを判定する
- **#242** 固定長レコードの桁数エラーを検出する
- **#243** 数値をゼロ埋めして固定桁へ整形する
- **#244** 文字列の左詰め・右詰めをVBAとPowerShellで比べる
- **#245** Shift_JISで文字数とバイト数が違うことを体験する
- **#246** 全銀フォーマット風の教育用固定長データをVBAで解析する
- **#247** 全銀フォーマット風の教育用固定長データをPowerShellで解析する
- **#248** ダミー振込データのHeader・明細・Trailer合計を照合する
- **#249** CRLFとLFの違いを同じテキストで確認する
- **#250** CSVのカンマ・ダブルクォート・改行を正しくEscapeする
- **#251** TSVならカンマ入り文字列をどう扱えるか比べる
- **#252** INIファイルを読み書きして昔ながらの設定ファイルを理解する
- **#253** XMLをPowerShellで読み、階層構造をたどる
- **#254** VBAでXML DOMを使って要素を読む
- **#255** COBOLのPIC風フィールド定義をExcel表から固定長へ変換する
- **#256** 桁位置のある古いログをVBA／PowerShellで表形式へ変換する

---

## 🔢 Binary / Hex / Encoding Lab

ファイルや文字列をバイト列として観察し、Hex・Encoding・Endianなどを目で理解する。

- **#257** PowerShellだけでミニHex Dump Viewerを作る
- **#258** Excel VBAで簡易Hex Viewerを作る
- **#259** PNG・JPEG・PDF・ZIPのFile SignatureをHexで見る
- **#260** XLSX・DOCX・PPTXの先頭がZIP系であることを確認する
- **#261** UTF-8 BOMのEF BB BFを実際に見る
- **#262** UTF-16 LEの文字列がバイト列でどう見えるか確認する
- **#263** CRLFが0D 0Aとして保存されることを見る
- **#264** Little EndianとBig Endianで整数の並びを比べる
- **#265** 整数を4バイトへ変換してHex表示する
- **#266** IEEE 754の浮動小数点をバイト列で眺める
- **#267** 大きなファイルをChunk単位で読む処理を作る
- **#268** Base64変換前後のバイト数を比べる
- **#269** GUIDを文字列と16バイト表現で比べる
- **#270** CRC32をPowerShellで実装してChecksumを理解する
- **#271** BMPヘッダーを読み取り画像サイズを取り出す

---

## 📚 Language Basics Lab

1サンプル1文法で、同じ処理をVBAとPowerShellに書いて違いを体験する。

- **#272** 変数って何？ VBAのDimとPowerShellの$変数を比べる
- **#273** 型って何？ String・Integer・Dateを比べる
- **#274** 文字列の結合・切り出しをVBAとPowerShellで比べる
- **#275** 配列を作る・追加する・取り出すを比べる
- **#276** Dictionary／Hashtableでキーと値を扱う
- **#277** If文で条件分岐を同じ問題で比べる
- **#278** For／For Each／foreachの違いを比べる
- **#279** Functionを作って同じ計算を呼び出す
- **#280** 引数って何？ ByVal／ByRefとparam()を比べる
- **#281** 戻り値はどう返る？ VBA FunctionとPowerShell Pipelineを比べる
- **#282** 値渡しと参照渡しで元の値が変わるか試す
- **#283** ローカル変数とグローバル変数のScopeを比べる
- **#284** Null・Empty・Nothing・$nullの違いを体験する
- **#285** On Errorとtry/catchで同じエラーを処理する
- **#286** ClassとObjectをVBAとPowerShellで最小実装する

---

## 🧰 Built-in Tools & Scripting Map

WindowsやOfficeで利用できる言語・スクリプト・コマンドの役割を、小さな実行例で使い分ける。

- **#287** cmd.exeとBatchは今どんな場面で使う？
- **#288** Windows PowerShell 5.1は何ができる？
- **#289** PowerShell 7はWindows PowerShell 5.1と何が違う？
- **#290** Windows Script HostとVBScriptの現在位置を知る
- **#291** JScript／WSHで簡単なスクリプトを動かして歴史を知る
- **#292** Office VBAは何が得意で何が苦手？
- **#293** Windows標準のcurl.exeでHTTPを確認する
- **#294** tar.exeでZIP／tarアーカイブを扱ってみる
- **#295** robocopyで大量ファイルコピーのログを読む
- **#296** certutilで証明書・Hash関連の基本情報を見る
- **#297** schtasksでTask Schedulerの登録内容を読む
- **#298** netshでネットワーク設定を読み取る
- **#299** wevtutilでEvent Logをコマンドから読む
- **#300** tasklist・taskkillとPowerShell Process操作を比べる

---

## 機械可読カタログ

全259件は [catalog/ideas.csv](./catalog/ideas.csv) にも保存しています。実装時に `status=idea` から公開サンプルへ昇格し、`samples/NNN-...` と `catalog/samples.csv` へ移します。
