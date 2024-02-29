#!/bin/bash
### 目的
# nvimコンテナ上に、編集したいコードが実行される環境と同じ環境を再現すること。
### 前提
# 1. コンテナ外で実行されること
# 2. コンテナが作られた直後に実行されること(「直後」とは、コンテナ作成後、他の操作をしていないということ)
# 3. 他のコンテナの/usr/ディレクトリが/mnt/usr/としてマウントされていること。
### 利用方法
# `docker compose up`等でコンテナを作成した後、コンテナに入らない状態で実行する。
### 注意点
# これはbashスクリプトなので、コンテナの外でも実行できてしまう。
# しかし、コンテナ外で実行されると、コンテナ外の環境が変わるかもしれない。
# そのためこのスクリプトでは、`docker exec`コマンドを利用することで、
# コンテナの外で実行してもコンテナ外の環境が変わらないことを保証している。

docker exec -u 0 nvimcontainer-nvim-1 rsync -rl /mnt/usr/ /usr
