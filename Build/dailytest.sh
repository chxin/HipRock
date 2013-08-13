makefilepath=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/
nodepath=/usr/local/bin/

if [ -f "${makefilepath}testlog.json" ]; then
    rm -f -r ${makefilepath}testlog.json
fi

make --makefile=Makefile --directory=${makefilepath} xctest

if [ $? -eq 0 ]; then
    echo "success"
    rm -f -r  ${makefilepath}testlog.json
else
    ${nodepath}node parseTestError.js
fi
