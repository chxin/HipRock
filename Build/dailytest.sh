makefilepath=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/
nodepath=/usr/local/bin/
make --makefile=Makefile --directory=${makefilepath} xctest

if [ $? -eq 0 ]; then
    echo "success"
else
    ${nodepath}node parseTestError.js
fi
