---
title: "Dockerfileを複数に分けてdocker-compose.ymlからまとめて起動する方法"
emoji: "🔥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [docker]
published: true
---
# はじめに
Dockerfileを複数に分けてdocker-compose.ymlで管理するときの備忘録です
## 動作環境
macOS 14.2.1 (23C71)
Docker 24.0.7
## 目標
- Dockerfileをディレクトリごとに分ける
- Docker-compose.ymlからDockerfileを指定する
# 手順
## Dockerfileをディレクトリごとに分ける
分けたいディレクトリにDockerfileを置く
今回の場合ｍ`api`と`app`に置いてる
```diff :ディレクトリ構成
  .
  ├── README.md
  ├── api
+ │   ├── Dockerfile <------
  │   ├── __init__.py
  │   ├── cruds
  │   ├── main.py
  │   └── models
  ├── app
+ │   ├── Dockerfile <------
  │   └── main.py
  ├── docker-compose.yml
  └── src
```
## Dokerfileごとに内容を書き分ける
:::details app
```app/Dockerfile
FROM python:3.9-buster
ENV PYTHONUNBUFFERED=1

WORKDIR /src
RUN pip install --upgrade pip

RUN python -m pip install streamlit requests

CMD [ "streamlit","run","main.py" ]
```
:::
:::details api 
```api/Dockerfile
FROM python:3.9-buster
ENV PYTHONUNBUFFERED=1

WORKDIR /src

RUN pip install fastapi uvicorn sqlalchemy aiomysql 

ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--reload"]
```
:::
## docker-compose.ymlを書き換える
`docker-compose.yml`でバックエンドとフロントエンドに分けて、`build:`に各Dockerfileが存在するディレクトリを書く。
:::message 
`/dockerfile`まで書かないこと
:::

```diff yml:docker-compose.yml
version: '3'
services:
  api:
+   build: api/
    volumes: 
      - .dockervenv:/src/.venv
      - ./api:/src
    ports:
      - 8000:8000
  app:
+   build: app/
    volumes:
      - ./app:/src
    ports:
      - 8501:8501
```

# おわりに
Dockerfileを分けることによって同一コンテナでは無くなるのでコンテナ間通信が必要になるため、次回はそのことについて書きます

