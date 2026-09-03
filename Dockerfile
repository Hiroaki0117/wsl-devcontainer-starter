# 3 本目の devcontainer.json と同じ中身を Dockerfile の語で書いたもの。
# devcontainer.json の image の行に当たる: Microsoft が配る Node 24 のイメージを土台にする
FROM mcr.microsoft.com/devcontainers/javascript-node:24

# GitHub の公式コマンド gh を入れる。git の認証情報を gh に聞かせるために使う
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends gh \
 && rm -rf /var/lib/apt/lists/*

# git が認証情報を求めたら gh に聞く (VS Code の中継の代わり)
RUN git config --system credential.helper '!gh auth git-credential'

# devcontainer.json の remoteUser の行に当たる。以降は node ユーザーで動く
USER node

# devcontainer.json の features の行に当たる: Claude Code を入れる
RUN npm install -g @anthropic-ai/claude-code

# Claude Code のログインの置き場。node ユーザーで作っておくと、ボリュームも node のものになる
RUN mkdir -p /home/node/.claude
ENV CLAUDE_CONFIG_DIR=/home/node/.claude
