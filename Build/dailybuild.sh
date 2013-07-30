makefilepath=~/BuildFolder/SourceCode/Master/BluesGit/Build/

#make xctest
make --makefile=Makefile --directory=${makefilepath} xcbuild

source ${makefilepath}dailycheckin.sh

