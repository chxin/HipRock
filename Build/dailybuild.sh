makefilepath=~/BuildFolder/SourceCode/Master/BluesGit/Build/
srcpath=~/BuildFolder/SourceCode/Master/BluesGit
nodepath=/usr/local/bin/
cd ${srcpath}
git checkout dev
git pull
cd ${makefilepath}
make --makefile=Makefile --directory=${makefilepath} xcclean
make --makefile=Makefile --directory=${makefilepath} xcbuild BUILDTYPE=DailyBuild

if [ $? -eq 0 ]; then
    echo "success"
else
    ${nodepath}node buildError.js
fi
