#!/bin/sh

buildnumber=$1
branch=dev
bundleversion=$2


if [ "$buildnumber" = "" ] || [ "$bundleversion" = "" ]; then
	echo incomplete parameter
	exit 1
fi

#path definitions
buildroot=/Users/buildserver/BuildFolder
projectdir=$buildroot/Blues/
makedir=$buildroot/Shell/
archivefolder=$buildroot/Archives
archiveurl=http://10.177.206.47:81/archive

#get branch code
cd $projectdir
git checkout -f $branch

if [ $? -eq 0 ]; then
	echo Branch $branch checkout success, will continue build
else
	echo Branch $branch checkout failed, will exit build.
	exit 1
fi

git pull

if [ $? -eq 0 ]; then
	echo Branch $branch update success, will continue build
else
	echo Branch $branch update failed, will exit build.
	exit 1
fi

python $makedir/updatebundleversion.py $projectdir/Trunk/Src/BluesPad/BluesPad-Info.plist $bundleversion
echo "[GIT]:Changed CFBundleVersion to ${bundleversion}"
git commit -a -m "[GIT]:Changed CFBundleVersion to ${bundleversion}"
git push

#clean and build
templatefolder=$buildroot/Templates
targetfolder=$archivefolder/DailyBuild/$buildnumber

echo Will build into $targetfolder
if [ -f "${targetfolder}/BluesPad.plist" ]; then
	echo "Error: buildnumber ${buildnumber} already exists!"
	exit 1
else
	mkdir -p $targetfolder
fi

make --makefile=makefile --directory=$makedir PROJECTDIR=$projectdir xcclean
make --makefile=makefile --directory=$makedir PROJECTDIR=$projectdir BUILDTYPE=DailyBuild OUTPUTDIR=$targetfolder xcbuild

cp $templatefolder/* $targetfolder/

if [ $? -eq 0 ]; then
    echo "Build Success"
else
	echo "Build error, please see log file"
	echo "${targetfolder}/build.log"
    #send mail
    python ${makedir}sendmail.py /DailyBuild/$buildnumber/build.log
    exit 1
fi

#change data source?

#update urls in plist
echo ${makedir}updatepackageurl.py ${targetfolder}/BluesPad.plist ${archiveurl}/DailyBuild/$buildnumber $bundleversion
python ${makedir}updatepackageurl.py ${targetfolder}/BluesPad.plist ${archiveurl}/DailyBuild/$buildnumber $bundleversion

#package
make --makefile=makefile --directory=$makedir xcpackage apppath=$targetfolder/BluesPad.app ipapath=$targetfolder/BluesPad.ipa

echo ""
echo "======Blues DailyBuild DB${buildnumber} Finished========" 
echo ""
exit 0