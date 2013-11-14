find . "(" -name "*.m" -or -name "*.h" -or -name "*.mm" -or -name "*.cpp" ")" -print0 | xargs -0 wc -l
