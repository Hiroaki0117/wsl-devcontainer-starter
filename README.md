# wsl-devcontainer-starter

WSL の Ubuntu に入れた Docker Engine の上で、VS Code の Dev Containers を使って「誰が開いても同じ開発環境」を作る最小の雛形です。中には Node 24・Claude Code・Vite + React の最小アプリが入ります。Claude Code は Opus 5・effort high で動くよう設定してあります。

## 必要なもの

- Windows 11 と WSL 2 の Ubuntu (`wsl --install` 済み)
- Ubuntu 側の Docker Engine (`docker run hello-world` が sudo 無しで通ること)
- Windows 側の VS Code と、拡張機能の WSL と Dev Containers

## 使い方 (3 手)

1. Ubuntu のターミナルで clone して VS Code で開く

   ```bash
   git clone https://github.com/Hiroaki0117/wsl-devcontainer-starter.git
   cd wsl-devcontainer-starter
   code .
   ```

2. VS Code の右下に出る **Reopen in Container** を押す (コマンドパレットの Dev Containers: Reopen in Container でも同じ)。初回はイメージの取得で数分かかる
3. VS Code のターミナル (Ctrl+`) で `claude` と打ち、ブラウザでログインする

アプリは `npm run dev` で起動し、Windows のブラウザで http://localhost:5173 を開きます。

## 中身

| ファイル | 役割 |
|---|---|
| `.devcontainer/devcontainer.json` | 環境の定義。Node 24 のイメージに Claude Code を足し、ポート 5173 を Windows へ転送し、Claude Code のログインをボリュームに残す |
| `.claude/settings.json` | Claude Code のモデルと effort (opus / high) |
| `index.html` `src/` | Vite + React の最小アプリ |
| `vite.config.js` | `server.host: true`。コンテナーの中では既定の localhost が IPv6 (::1) だけを聞き、VS Code の転送 (127.0.0.1) が届かないため |
| `.devcontainer/devcontainer-lock.json` | Dev Containers が自動で作る。足した機能 (Claude Code) の版を固定する |

## VS Code を使わずに立てる (docker compose)

同じ環境を、VS Code なしで `docker compose` だけで立てる版です。`compose.yaml` と `Dockerfile` が devcontainer.json と同じ中身を Docker の語で書いています。Ubuntu 側で `gh auth login` を済ませておくと、コンテナーの中からの `git push` が通ります (ログインファイルを読み取り専用で貸す作り)。

```bash
docker compose up -d --build       # イメージを作り、app (Node + Claude Code) と db (PostgreSQL 18) を起動
docker compose exec app bash       # コンテナーの中に入る (VS Code のターミナルの代わり)
npm ci && npm run dev              # 中で。Windows のブラウザで http://localhost:5173
docker compose down                # 止める。ボリューム (Claude Code のログインと DB の中身) は残る
```

| ファイル | 役割 |
|---|---|
| `Dockerfile` | イメージの作り方。Node 24 のイメージを土台に gh と Claude Code を足す (devcontainer.json の image と features) |
| `compose.yaml` | コンテナーの動かし方。ボリューム・ポート 5173・GitHub のログインの貸し出し・PostgreSQL |

`docker compose down -v` は compose.yaml に書いたボリュームを全部消します (Claude Code のログインも)。DB だけ消すなら `docker volume rm wsl-devcontainer-starter_pgdata` を使ってください。
