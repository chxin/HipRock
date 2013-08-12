makefilepath=~/BuildFolder/SourceCode/Master/BluesGit/Build/

make --makefile=Makefile --directory=${makefilepath} xctest

if [ $? -eq 0 ]; then
    echo "success"
else
    node parseTestError.js
fi
