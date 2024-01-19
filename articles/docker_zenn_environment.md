---
title: "DockerにZennCLIの環境構築"
emoji: "🐋"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [docker,zenn]
published: true
---
# はじめに
タイトル通り「DockerにZennCLIの環境構築」するときの備忘録です
## 動作環境
macOS 14.2.1 (23C71)
Docker 24.0.7
## 目標
- ver14のnodeコンテナを作成
- npmでZennCLIをインストール
- docker-composeを使ってコンテナを立ち上げたときにプレビューできるようにする
- VSCode拡張機能でより快適な執筆環境を作る
# TL/DR;
## ディレクトリ構成
下記に示す`Dockerfile`と`docker-compose.yml`をコピペしたら構築できる
```bash:ディレクトリ構成
.
├── articles
│   └── 
├── docker
│   └── Dockerfile
├── docker-compose.yml
```
:::details dockerfile
```dockerfile:dockerfile
FROM node:14

ENV NODE_PATH /opt/node_modules

WORKDIR /workspace

RUN npm init --yes && \
    npm install -g zenn-cli@latest && \
    npx zenn init
```
:::
:::details docker-compose.yml
```yml:docker-compose.yml
version: "3"

services:
  zenn:
    build:
      context: .
      dockerfile: docker/Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - ".:/workspace"
    command: npx zenn preview
```
:::
## VSCode拡張機能
![](https://storage.googleapis.com/zenn-user-upload/2eb092472595-20240119.png)
`Zenn Preview for github.dev`をインストールすることでVSCode上でプレビューができたり、GUIで記事作成できたりする
# 手順
## ディレクトリ構成
```bash:ディレクトリ構成
.
├── articles
│   └── 
├── docker
│   └── Dockerfile
├── docker-compose.yml
```
最初に上記の通りディレクトリを作る。
`articles`配下に記事が保存されるようになる
booksも管理したいなら`articles`と同じ階層に`books`ディレクトリを作成する
## ver14のnodeコンテナを作成
ZennCLIはVer14のNodeしか対応していないのでそのDockerfileを作成する
```dockerfile:Dockerfile
FROM node:14

ENV NODE_PATH /opt/node_modules

WORKDIR /workspace

RUN npm init --yes && \
    npm install -g zenn-cli@latest && \
    npx zenn init
```
コンテナをビルドするときにZennCLIをインストールして初期化する
## docker-composeを使ってコンテナを立ち上げたときにプレビューできるようにする
```yml:docekr-compose.yml
version: "3"

services:
  zenn:
    build:
      context: .
      dockerfile: docker/Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - ".:/workspace"
    command: npx zenn preview
```
`$ docker-compose up`したとき[http://localhost:8000]に記事のプレビューが表示されるようになる
## 記事の作成
コンテナを立ち上げて`exec`して記事を作成
```bash
$ docker-compose up
$ docker-compose exec zenn zenn new:articles --title test
```
`--title`オプションをつけることでそのままタイトルまで設定できる
その他にも絵文字とかも設定できる
## 画像の追加
### ディレクトリで管理する方法
```bash
.
├── articles
│   └── docker_zenn_environment.md
├── docker
│   └── Dockerfile
├── docker-compose.yml
├── images
│   ├── zenn.gif
│   ├── zenn1.gif
│   └── zenn3.gif
└── zenn.code-workspace
```
`images`ディレクトリを作成し、その配下に追加していくことで参照できる
↓例
```bash
- ウィンドウプレビュー
![](/images/zenn3.gif)
```
:::message
`/images`のように先頭に/をつけないといけない
:::
### ZennのアップロードページからURLを取得する
https://zenn.dev/dashboard/uploader
## リアルタイムプレビュー
記事が作成できたら[http://localhost:8000]にアクセスすることでプレビューで確認できる
![](https://storage.googleapis.com/zenn-user-upload/f6e7612c8d6a-20240119.png)
↓リアルタイムで反映される
![zenn.gif](/images/zenn1.gif)
## 記事の投稿
zennと連携済みのGitHubレポジトリにpushすることで投稿されます
## VSCode拡張機能でより快適な執筆環境を作る
### Zenn Preview for github.dev
![](https://storage.googleapis.com/zenn-user-upload/2eb092472595-20240119.png)
インストールするとアクティビティバーにZennのアイコンが追加される
![](https://storage.googleapis.com/zenn-user-upload/f53d4146f390-20240119.png)
![](https://storage.googleapis.com/zenn-user-upload/6fe1e8e7646b-20240119.png)
- ウィンドウプレビュー
![](/images/zenn3.gif)
### スニペットの登録
記事構成をスニペット化する
![](https://storage.googleapis.com/zenn-user-upload/d3d6ef9419f0-20240119.png)
```json:snippets
{
 {
	"prefix": "zenn_article",
	    "body": [
			"# はじめに"
			"$1"
			"## 動作環境"
			"$2"
			"## 目標"
			"$3"
			"# TL/DR;"
			"$4"
			"# 手順"
			"$5"
			"# おわりに"
			"$6"
			"# 参考"
			"$7"
		],
		"description": "Template with Tags",
	}
}
```
prefix入力してもスニペットが表示されない場合は`setting.json`に以下を追加する
```json:setting.json
  "[markdown]":  {
    "editor.wordWrap": "on",
    "editor.quickSuggestions": {
        "comments": "on",
        "strings": "on",
        "other": "on"
    },
    "editor.snippetSuggestions": "top"
}
```
# おわりに
ローカル環境を汚さずにZennCLIの環境構築できた
devcontainerで色々やっても面白そう

# 参考
- https://aadojo.alterbooth.com/entry/2023/01/16/110000
- https://qiita.com/CopyAndPaste/items/6c04950d9fe57c6cfe76