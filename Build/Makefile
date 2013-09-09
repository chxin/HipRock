BluesPath:=../Trunk/Src/
BluesBuild:=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/
xctoolpath:=/Users/BuildServer/BuildFolder/Tools/xctool/bin/
webserverpath:=/Users/BuildServer/WebServer/
#identity:=iPhone Distribution:cn.com.schneider-electric.BluesPad
#identity:=iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)
#provision:=Blues_AdHoc.mobileprovision

xcclean:
	$(xctoolpath)xctool -sdk iphonesimulator CODE_SIGN_IDENTITY="${identity}"  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration AdHocDistribution -project $(BluesPath)Blues.xcodeproj -scheme BluesPad clean

xcbuild:
	$(xctoolpath)xctool  SDKROOT=iphoneos6.1 CONFIGURATION_BUILD_DIR=$(BluesBuild) ONLY_ACTIVE_ARCH=NO -configuration ${BUILDTYPE} -project $(BluesPath)Blues.xcodeproj -scheme BluesPad build 


xctest:
	$(xctoolpath)xctool -sdk iphonesimulator  ONLY_ACTIVE_ARCH=NO  -configuration Debug  -project $(BluesPath)Blues.xcodeproj -scheme CommonTests  test -test-sdk iphonesimulator -freshInstall -freshSimulator -reporter json-stream:testlog.json  

xctestcommand:
	$(xctoolpath)xctool -sdk iphonesimulator  ONLY_ACTIVE_ARCH=NO  -configuration Debug  -project $(BluesPath)Blues.xcodeproj -scheme CommonTests  test -test-sdk iphonesimulator -freshInstall -freshSimulator



xcpackage:
	xcrun -sdk iphoneos PackageApplication  "BluesPad.app" -o "${webserverpath}${FOLDER}BluesPad.ipa"
