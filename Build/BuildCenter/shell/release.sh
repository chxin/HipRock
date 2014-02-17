#!/bin/sh

version=$1

if [ "$version" = "" ]; then
	echo incomplete parameter
	exit 1
fi

#path definitions
buildroot=/Users/buildserver/BuildFolder
projectdir=$buildroot/Blues/
makedir=$buildroot/Shell/
archivefolder=$buildroot/Archives
archiveurl=http://10.177.206.47:81/archive

#copy ir version to release and delete *.ipa
templatefolder=$buildroot/Templates
sourcefolder=$archivefolder/InternalRelease/$version
targetfolder=$archivefolder/Release/$version

echo Will build into $targetfolder
if [ -f "${targetfolder}/BluesPad.plist" ]; then
	echo "Error: Release ${version} already exists!"
	exit 1
else
	mkdir -p $targetfolder
fi

cp -R $sourcefolder/BluesPad.app $targetfolder/BluesPad.app
cp -R $sourcefolder/BluesPad.app.dSYM $targetfolder/BluesPad.app.dSYM
cp $templatefolder/* $targetfolder/

#change datasource in configuration.plist in $apppath
plutil -convert xml1 ${targetfolder}/BluesPad.app/Configuration.plist
python ${makedir}updatedatasource.py ${targetfolder}/BluesPad.app/Configuration.plist 'production'
plutil -convert binary1 ${targetfolder}/BluesPad.app/Configuration.plist

#resign app
codesign -d --entitlements ${targetfolder}/entitlements.plist ${targetfolder}/BluesPad.app
rm -R ${targetfolder}/BluesPad.app/_CodeSignature
codesign -f -s "iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)" ${targetfolder}/BluesPad.app --entitlements ${targetfolder}/entitlements.plist -v

#update urls in plist
#sed "s/##rooturl##/${url}/g" $targetfolder/BluesPad.plist
#sed "s/##bundleversion##/${bv}/g" $targetfolder/BluesPad.plist
python ${makedir}updatepackageurl.py ${targetfolder}/BluesPad.plist ${archiveurl}/Release/$version 8 

#package

make --makefile=makefile --directory=$makedir xcpackage apppath=$targetfolder/BluesPad.app ipapath=$targetfolder/BluesPad.ipa

echo ""
echo "======Blues Release ${version} Finished========" 
echo ""
exit 0