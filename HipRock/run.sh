oldVer=`awk -F= '/ROCK_VERSION/{print $2}' android/gradle.properties |tail -n 1`
currCommit=$(git rev-parse --short HEAD)
filePath="./android/app/build/outputs/apk/app-internal-release-$version.apk"

# echo "Please input the new version?The old version is:$oldVer"
# read version
# while([[ $version == '' ]])
# do
# echo "Error! Please input the new version?The old version is:$oldVer"
# read version
# done
version=1.0.0
# sed -i '' 's/$oldVer/$version/g' android/gradle.properties
# sed -i "s/0.5.2/0.5.3/g" android/gradle\.properties
sed -i '' "s/$oldVer/$version/g" `grep $oldVer -rl  android/gradle.properties`

cp ./android/customModules/ShareModule.java ./node_modules/react-native/ReactAndroid/src/main/java/com/facebook/react/modules/share/ShareModule.java
rm -rf ./node_modules/react-native-svg/android/build
source configEnvScripts/findAndReplace.sh && getFileAndChangeJcenter

cd android && ./gradlew assembleRelease
cd ..

# rm ../build_file/*unaligned.apk

curl -F "file=@$filePath" -F "uKey= 7d42c69844b88157360fe2dc141fdf1a" -F "_api_key= be1290e71bb2fab7a9547cda2ee37d7b" -F "installType=2" -F "password=123456" -F "updateDescription=$currCommit" http://qiniu-storage.pgyer.com/apiv1/app/upload
