makefilepath=~/BuildFolder/SourceCode/Master/BluesGit/Build/
srcpath=~/BuildFolder/SourceCode/Master/BluesGit
cd ${srcpath}
git pull
cd ${makefilepath}
#make xctest
make --makefile=Makefile --directory=${makefilepath} xcclean xcbuild


