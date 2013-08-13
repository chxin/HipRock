makefilepath=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/

make --makefile=Makefile --directory=${makefilepath} xcpackage

if [ $? -eq 0 ]; then
    rm -r -f ${makefilepath}BluesPad.app
    rm -r -f ${makefilepath}BluesPad.app.dSYM
fi
