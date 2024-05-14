---
title: "[Linux] tarコマンドで圧縮/解凍"
emoji: "🐕"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Linux]
published: true
---
# 圧縮形式の種類
* gzip
標準
* bzip2
より高い圧縮率
* xz
もっと高い圧縮率

# 単体ファイル
test.txtを圧縮する
```
% touch test.txt
% cat > test.txt
% ls -l test.txt | awk '{print $5}'
402
```
## 圧縮
### gzip
```
% gzip test.txt
```
元ファイルを残す場合
```
% gzip -c test.txt > test.txt.gz
```
### bzip2
```
% bzip2 test.txt
```
元ファイルを残す場合
```
% bzip2 -c test.txt > test.txt.bz
```
## 解凍
### gzip
```
% gzip -d test.txt.gz
```
### bzip2
```
% bzip2 -d test.txt.bz
```

bzipのほうがgzipより圧縮できていない…？なぜだ
```
% ls -l test.* |awk '{print $5,$9}'
402 test.txt
47 test.txt.bz2
36 test.txt.gz
```
# フォルダ
`create-next-app`したディレクトリを圧縮していきます。
```
% du -sh next-app
327M    next-app
```
## 圧縮
### gzip
```
% tar cvzf next-app.tar.gz next-app 
```
* `-c`: 新規ディレクトリを作成 (create)
* `-v`: 詳細表示 (verbose)
* `-z`: gzipを指定
* `-f`: ファイル名の指定 (filename)

### bzip2
```
% tar cvjf next-app.tar.bz2 next-app 
```
* `-j`: bzip2の指定
### xz
```
% tar cvJf next-app.tar.xz next-app 
```
* `-J`: xzの指定

xz君時間かかりすぎだ…
```
% du -sh next-app.tar.gz next-app.tar.bz next-app.tar.xz next-app
 80M    next-app.tar.gz
 59M    next-app.tar.bz2
 40M    next-app.tar.xz
327M    next-app
```
## 解凍
### gzip
```
% tar xvzf next-app.tar.gz
```
cの代わりにxをつける
### bzip2
```
% tar xvjf next-app.tar.bz
```
### xz
```
% tar xvJf next-app.tar.gz
```
# 参考
https://qiita.com/wnoguchi/items/cb0fa7c11b119e96f1e5
https://qiita.com/supersaiakujin/items/c6b54e9add21d375161f