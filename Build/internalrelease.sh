makefilepath=~/BuildFolder/SourceCode/Master/BluesGit/Build/
srcpath=~/BuildFolder/SourceCode/Master/BluesGit
nodepath=/usr/local/bin/
webserverpath=~/WebServer/
cd ${srcpath}
#git checkout dev
git pull
cd ${makefilepath}
make --makefile=Makefile --directory=${makefilepath} xcclean
make --makefile=Makefile --directory=${makefilepath} xcbuild BUILDTYPE=InternalRelease


if [ $? -eq 0 ]; then
   if [ -d "${webserverpath}IR/$1" ]; then
      echo "the same version folder exists"
      exit
    else
      mkdir "${webserverpath}IR/$1"
    fi

    make --makefile=Makefile --directory=${makefilepath} xcpackage FOLDER=IR/$1/

    if [ $? -eq 0 ]; then
        rm -r -f ${makefilepath}BluesPad.app
        rm -r -f ${makefilepath}BluesPad.app.dSYM
        cp ${webserverpath}BluesPad-t.plist ${webserverpath}IR/$1/BluesPad.plist
        cp ${webserverpath}AppLogo.png ${webserverpath}IR/$1
        cp ${webserverpath}AppLogo@2x.png ${webserverpath}IR/$1
        ${nodepath}node ${makefilepath}updatePlist.js IR $1
        ${nodepath}node ${makefilepath}updateHtml.js IR $1
        git tag -a $1 -m "Internal Release $1"
        git push origin --tags
    fi
else
    ${nodepath}node buildError.js
fi
