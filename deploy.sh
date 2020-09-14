#!/bin/bash

commit_message=$1

SITE_SOURCE="/home/lu/my_blog"
PUBLIC_DIR="/home/lu/code/git_project/simon-lu.github.io"
cd "${SITE_SOURCE}"
rm -rf "${SITE_SOURCE}/"public/*

git add .
git commit -m "${commit_message}"
git push origin master 

echo "上传源文件成功"

# 将 vec 修改为你的主题名
hugo || exit 1
rm -rf "${PUBLIC_DIR}/"* && cp -R "${SITE_SOURCE}/public/"* "${PUBLIC_DIR}/"
cd "${PUBLIC_DIR}"
git add .
git commit -m "update blog"
git push origin master --force

echo "网站部署成功"
