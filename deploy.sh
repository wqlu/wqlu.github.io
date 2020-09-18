#!/bin/bash

commit_message=$1

if [ -d "/public/" ];then
    rm -rf public
else
    echo "public not exist"
fi

git add .
git commit -m "${commit_message}"
git push origin blog

echo "源码上传成功"
