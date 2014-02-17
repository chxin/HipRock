#!/bin/sh

branch=$1
version=$2
bundleversion=$3


if [ "$branch" = "" ] || [ "$version" = "" ] || [ "$bundleversion" = "" ]; then
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

#clean and build
templatefolder=$buildroot/Templates
targetfolder=$archivefolder/InternalRelease/$version

echo Will build into $targetfolder
if [ -f "${targetfolder}/BluesPad.plist" ]; then
	echo "Error: IR ${version} already exists!"
	exit 1
else
	mkdir -p $targetfolder
fi

make --makefile=makefile --directory=$makedir PROJECTDIR=$projectdir xcclean
make --makefile=makefile --directory=$makedir PROJECTDIR=$projectdir BUILDTYPE=Release OUTPUTDIR=$targetfolder xcbuild

if [ $? -eq 0 ]; then
    echo "Build Success"
else
	echo "Build error, please see log file"
	echo "${targetfolder}/build.log"
    #send mail
    python ${makedir}sendmail.py /InternalRelease/$version/build.log
    exit 1
fi

cp $templatefolder/* $targetfolder/

#change data source?
#echo ${makedir}updatedatasource.py ${targetfolder}/BluesPad.app/Configuration.plist 'test'
#plutil -convert xml1 ${targetfolder}/BluesPad.app/Configuration.plist
#python ${makedir}updatedatasource.py ${targetfolder}/BluesPad.app/Configuration.plist 'test'
#plutil -convert binary1 ${targetfolder}/BluesPad.app/Configuration.plist

#resign app
#rm -R ${targetfolder}/BluesPad.app/_CodeSignature
#codesign -f -s "iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)" ${targetfolder}/BluesPad.app

#update urls in plist
echo bundleversion
echo ${makedir}updatepackageurl.py ${targetfolder}/BluesPad.plist ${archiveurl}/InternalRelease/$version ${bundleversion} 
python ${makedir}updatepackageurl.py ${targetfolder}/BluesPad.plist ${archiveurl}/InternalRelease/$version ${bundleversion}     #plist,url,bundleversion


#package
make --makefile=makefile --directory=$makedir xcpackage apppath=$targetfolder/BluesPad.app ipapath=$targetfolder/BluesPad.ipa

#make tag
git tag -a ${version} -m "Internal Release ${version}"
git push origin --tags


echo ""
echo "======Blues InternalRelease ${version} Finished========" 
echo ""
exit 0