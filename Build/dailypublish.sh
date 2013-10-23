makefilepath=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/
nodepath=/usr/local/bin/

make --makefile=Makefile --directory=${makefilepath} xcpackage FOLDER=

if [ $? -eq 0 ]; then
    rm -r -f ${makefilepath}BluesPad.app
    rm -r -f ${makefilepath}BluesPad.app.dSYM
    ${nodepath}node ${makefilepath}updateHtml.js 
fi
