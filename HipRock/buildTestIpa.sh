# source ./buildNumber.sh
# currCommit=$(git rev-parse --short HEAD)
# buildNumber=`getParamAndPlusone`

# description="$currCommit"_"$buildNumber"

OUTPUTDIR="./buildIOSTemp"
SCHEMETEST="HipRock_Test"
SCHEMEPROD="HipRock_Prod"
APP_PROJECTPATH="./ios/HipRock.xcodeproj"
PLIST_PATH='./ios/HipRock/Info.plist'

# echo "Please enter the version?like the 1.0.0"
# read version
# while([[ $version == '' ]])
# do
# echo "Error! Please enter the version?like the 1.0.0"
# read version
# done
version=1.0.0

APPNAME='HipRock_V'$version

git checkout ${PLIST_PATH}
. ./mergeTest.sh
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version}" ${PLIST_PATH}
rm "$OUTPUTDIR/$APPNAME/$SCHEMETEST.ipa"
xcodebuild -project "$APP_PROJECTPATH" -scheme "$SCHEMETEST" archive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -quiet
xcodebuild -exportArchive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -exportPath "$OUTPUTDIR/$APPNAME" -exportOptionsPlist "exportTestOptions.plist" -quiet
curl -F "file=@$OUTPUTDIR/$APPNAME/$SCHEMETEST.ipa" -F 'uKey=7d42c69844b88157360fe2dc141fdf1a' -F '_api_key=be1290e71bb2fab7a9547cda2ee37d7b' 'https://www.pgyer.com/apiv1/app/upload'

# curl -F "file=@$OUTPUTDIR/$APPNAME/$SCHEMETEST.ipa" -F "uKey= 24af41e3b5e5117e773a733378aefa29" -F "_api_key= 0691c7489e57a5158796f6e1e7e988bd" -F "installType=2" -F "password=123456" -F "updateDescription=$description" http://qiniu-storage.pgyer.com/apiv1/app/upload

# git checkout ${PLIST_PATH}
# . ./mergeProd.sh
# /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${version}" ${PLIST_PATH}
# rm "$OUTPUTDIR/$APPNAME/$SCHEMEPROD.ipa"
# xcodebuild -project "$APP_PROJECTPATH" -scheme "$SCHEMEPROD" archive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -quiet
# xcodebuild -exportArchive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -exportPath "$OUTPUTDIR/$APPNAME" -exportOptionsPlist "exportProdOptions.plist" -quiet
# curl -F "file=@$OUTPUTDIR/$APPNAME/$SCHEMEPROD.ipa" -F "uKey= 24af41e3b5e5117e773a733378aefa29" -F "_api_key= 0691c7489e57a5158796f6e1e7e988bd" -F "installType=2" -F "password=123456" -F "updateDescription=$description" http://qiniu-storage.pgyer.com/apiv1/app/upload
