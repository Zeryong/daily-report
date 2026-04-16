#!/bin/bash
# scan-commits.sh - 扫描指定目录下所有 git 仓库的当日提交
# 用法: bash scan-commits.sh [scan_directory]

SCAN_DIR="${1:-c:/development/code/}"
TODAY=$(date +%Y-%m-%d)
TOMORROW=$(date -d "$TODAY + 1 day" +%Y-%m-%d 2>/dev/null || date -v+1d +%Y-%m-%d 2>/dev/null)

found_any=false

for dir in "$SCAN_DIR"/*/; do
    if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
        commits=$(git -C "$dir" log --all \
            --since="${TODAY}T00:00:00" \
            --until="${TOMORROW}T00:00:00" \
            --pretty=format:"COMMIT_START%nHASH:%H%nSHORT:%h%nAUTHOR:%an%nDATE:%ai%nMESSAGE:%s%nCOMMIT_END" \
            --stat 2>/dev/null)

        if [ -n "$commits" ]; then
            found_any=true
            project_name=$(basename "$dir")
            echo "=== PROJECT: ${project_name} ==="
            echo "PATH: ${dir}"
            echo "$commits"
            echo ""
        fi
    fi
done

if [ "$found_any" = false ]; then
    echo "NO_COMMITS_TODAY"
fi
