#!/bin/bash

# # 设置代理
export http_proxy="http://127.0.0.1:8001"
export HTTP_PROXY="http://127.0.0.1:8001"
export https_proxy="http://127.0.0.1:8001"
export HTTPS_PROXY="http://127.0.0.1:8001"

# 检查pub缓存目录权限
if [ ! -w "$HOME/.pub-cache" ]; then
    echo "修复pub缓存目录权限..."
    sudo chown -R $(whoami):staff ~/.pub-cache
    sudo chmod -R 755 ~/.pub-cache
fi

# 发布包
unset PUB_HOSTED_URL
flutter pub publish  

# 恢复中国镜像
export PUB_HOSTED_URL="https://pub.flutter-io.cn"

# unset PUB_HOSTED_URL & flutter pub upgrade
