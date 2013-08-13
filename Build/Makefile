BluesPath:=../Trunk/Src/
BluesBuild:=~/BuildFolder/SourceCode/Master/BluesGit/Build/
xctoolpath:=~/BuildFolder/Tools/xctool/bin/
webserverpath:=/Users/BuildServer/WebServer/
#identity:=iPhone Distribution:cn.com.schneider-electric.BluesPad
#identity:=iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)
#provision:=Blues_AdHoc.mobileprovision

xcclean:
	$(xctoolpath)xctool -sdk iphonesimulator CODE_SIGN_IDENTITY="${identity}"  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration AdHocDistribution -project $(BluesPath)Blues.xcodeproj -scheme BluesPad clean

xcbuild:
	$(xctoolpath)xctool  SDKROOT=iphoneos6.1 CONFIGURATION_BUILD_DIR=$(BluesBuild) ONLY_ACTIVE_ARCH=NO -configuration DailyBuild -project $(BluesPath)Blues.xcodeproj -scheme BluesPad build 


xctest:
	xctool -sdk iphonesimulator  ONLY_ACTIVE_ARCH=NO  -configuration Debug  -project $(BluesPath)Blues.xcodeproj -scheme CommonTests  test -test-sdk iphonesimulator -freshInstall -freshSimulator -reporter json-stream:testlog.json  


xcpackage:
	xcrun -sdk iphoneos PackageApplication -v "BluesPad.app" -o "${webserverpath}BluesPad.ipa"
