#!/bin/bash

# 確認檔案是否存在
if [[ ! -f words.txt ]]; then
    echo "Error: File 'words.txt' not found!"
    exit 1
fi

# 處理文件內容：小寫化、去標點、按行分詞、統計頻率、排序、取最大值
result=$(cat words.txt | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | tr ' ' '\n' | grep -v '^$' | sort | uniq -c | sort -nr | head -n 1)

# 檢查是否為空值
if [[ -z $result ]]; then
    echo "Error: No words found in 'words.txt'."
    exit 1
fi

# 格式化输出
count=$(echo "$result" | awk '{print $1}')
word=$(echo "$result" | awk '{print $2}')
echo "$count $word"
