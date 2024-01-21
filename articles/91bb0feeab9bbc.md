---
title: "[Colab]Colab上でFastAPIのサーバーを立てる"
emoji: "🪐"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Python,Colab,ngrok,FastAPI]
published: true
---
# はじめに
ngrokを使ってColab上からFastAPIサーバーを立てる備忘録です
## 目標
- ColabでFastAPIのエンドポイントを作る
- ngrokでサーバーを外部に公開する
# 手順
```python
!pip install -q fastapi nest-asyncio uvicorn pyngrok 

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import nest_asyncio
from pyngrok import ngrok
import uvicorn

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)

@app.get('/')
async def root():
    return {'hello': 'world'}


ngrok.set_auth_token("<access_token>")

ngrok_tunnel=ngrok.connect(8000)
print('PUBLIC_URL:',ngrok_tunnel.public_url)
nest_asyncio.apply()
uvicorn.run(app,port=8000)
```
## ライブラリ
- fastapi 
- nest_asyncio: 実行された以下のコードでいい感じに非同期処理ができるようになるらしい
- uvicorn: FastAPIサーバを立てる
- pyngrok: APIサーバを外部に公開
- `from fastapi.middleware.cors import CORSMiddleware`: FastAPIサーバのCORSを許可
## CORSMiddleware
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)
```
- allow_origins: すべてのオリジンからのアクセスを許可
- allow_credentials: クッキーとか許可
- alllow_methos: CRUD処理を許可
- allow_headers: ヘッダーを許可
## FastAPI
```json
{'hello':'world'}
```
というJSONを返す
## ngrok
- [ngrok](https://dashboard.ngrok.com/get-started/setup/macos)にアクセスしてアクセストークンを取得
- `ngrok.set_auth_token("<access_token>")`に貼り付け
- `ngrok_tunnel=ngrok.connect(8000)`: ローカルホスト8000番を外部に公開
- `uvicorn.run(app,port=8000)`: FastAPIサーバをローカルホスト8000番に公開