FROM node:14

ENV NODE_PATH /opt/node_modules

WORKDIR /workspace

RUN apt-get -y update && \ 
    apt-get -y clean 
#-y: yesを選択
#--no-install-recomends: 依存パッケージのうち、recommendsはインストールしない
#apt-get -y clean: キャッシュとか削除してるらしい
#npm install -g: プロジェクトだけじゃなくてシステム全体で使えるようになるらしい
#npx zenn init: zennのディレクトリ構成を作ってるらしい
RUN npm init --yes && \
    npm install -g zenn-cli@latest && \
    npx zenn init