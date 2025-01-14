import os
from collections import Counter
import re

# 確認檔案是否存在
file_path = "words.txt"
if not os.path.isfile(file_path):
    print(f"Error: '{file_path}' file not found!")
    exit(1)

# 讀取文件內容
with open(file_path, "r") as file:
    content = file.read()

# 轉為小寫, 並且去除標點符號
words = re.findall(r'\b\w+\b', content.lower())

# 計算每個單詞出現的次數
word_counts = Counter(words)

# 找出出現次數最多的單詞
most_common_word, frequency = word_counts.most_common(1)[0]

# 輸出結果
print(f"{frequency} {most_common_word}")
