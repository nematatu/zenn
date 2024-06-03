---
title: "[Linuxコマンド] 標準出力から該当文字のみハイライトしたい！"
emoji: "😸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Linux,unix,mac]
published: true
---
# はじめに
![](https://storage.googleapis.com/zenn-user-upload/d48c58bad393-20240603.png)

赤くハイライトされてる。こんなことをしたい

## 動作環境
      System Version: macOS 14.4 (23E214)

# 手順
## grepを使う方法
```bash
% ls -l | grep --color=auto -e '$' -e 'hackathon'

or

% ls -l | grep --color=auto -E "hackathon|$"
```

## dev-shell-essentials
```bash
% git clone https://github.com/kepkin/dev-shell-essentials.git
% cd dev-shell-essentials
% source dev-shell-essentials.sh
```

インストールはできたけど指定した文字列が`0`になっちゃってよくわからん。パス
## colout
https://github.com/nojhan/colout

```bash
% pip install colout
```

:::details macでpipしようとしたら、怒られた
```bash
%  pip install colout

error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try brew install
    xyz, where xyz is the package you are trying to
    install.

    If you wish to install a Python library that isn't in Homebrew,
    use a virtual environment:

    python3 -m venv path/to/venv
    source path/to/venv/bin/activate
    python3 -m pip install xyz
```

めっちゃ怒られた
以下↓で解決
```bash
% pip install colout --break-system-packages
```
https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3

毎回長いオプション付けるのめんどいので、デフォルトでこのオプションを付けるようにする
`~/.config/pip/pip.conf`に以下を追加する
```
[global]
break-system-packages = true
```
もし、`~/.config/pip/pip.conf`が存在しなかったら以下で作る
```
% mkdir -p ~/.config/pip
% vim ~/.config/pip/pip.conf
```
`-p`オプションで間のディレクトリを一気に作る
:::

```bash
% ls -l | colout "hackathon" blue
```

![](https://storage.googleapis.com/zenn-user-upload/53f0ae6810e6-20240604.png)
*青にハイライトされた*

# おわりに
疲れた〜
# 参考
https://orebibou.com/ja/home/201602/20160205_001/