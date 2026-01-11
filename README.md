# Nomitomo (飲み友) App

「飲み友達探し」を目的としたスマートフォン専用アプリです。

## 技術スタック
- **Backend**: FastAPI (Python), SQLAlchemy, SQLite, WebSockets
- **Mobile**: Flutter, Riverpod, GoRouter, flutter_line_sdk
- **Auth**: LINE Login

## プロジェクト構造
- `/backend`: FastAPIを使用したサーバーサイドコード
- `/mobile`: Flutterを使用したモバイルクライアントコード

---

## セットアップガイド

### 1. バックエンドの準備
1.  **環境変数の設定**
    `backend/.env` ファイルを作成し、以下の内容を設定してください。
    ```env
    SECRET_KEY=your_secret_key_here
    DATABASE_URL=sqlite+aiosqlite:///./local.db
    LINE_CHANNEL_ID=your_line_channel_id
    ```
2.  **依存関係のインストール**
    ```bash
    cd backend
    pip install -r requirements.txt
    ```
3.  **サーバーの起動**
    ```bash
    uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
    ```

### 2. モバイルアプリの準備
1.  **依存関係のインストール**
    ```bash
    cd mobile
    flutter pub get
    ```
2.  **コード生成**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **LINE Loginの設定**
    - `mobile/lib/main.dart` の `LineSDK.instance.setup('YOUR_LINE_CHANNEL_ID')` を実際のChannel IDに書き換えてください。
    - **iOS**: `ios/Runner/Info.plist` に LINE SDK 向けの設定（URL Scheme等）を追加する必要があります。
    - **Android**: `android/app/build.gradle` に `manifestPlaceholders` を設定する必要があります。
    詳細は [flutter_line_sdk 公式ドキュメント](https://pub.dev/packages/flutter_line_sdk) を参照してください。

### 3. 機能の検証
- **チャット (WebSocket)**
  バックエンドが起動している状態で、以下のスクリプトを実行してリアルタイム通信を検証できます。
  ```bash
  python3 backend/verify_ws.py
  ```

---

## 主な機能
- **友達をさがす**: 「募集中」のユーザーを一覧表示し、リアルタイムでのチャットを開始可能。
- **お店のおすすめ**: 美味しかったお店を共有。投稿は24時間の待機時間を経て全体公開されます。
- **リアルタイムチャット**: WebSocketを使用した低遅延なメッセージング。
- **LINE連携**: 面倒な登録なしで、既存のLINEアカウントで即座に利用開始。
