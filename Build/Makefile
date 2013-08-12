BluesPath:=../Trunk/Src/
BluesBuild:=~/BuildFolder/SourceCode/Master/BluesGit/Build/
xctoolpath:=~/BuildFolder/Tools/xctool/bin/
webserverpath:=/Users/BuildServer/WebServer/
#identity:=iPhone Distribution:cn.com.schneider-electric.BluesPad
identity:=iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)
provision:=Blues_AdHoc.mobileprovision
default:
	xcodebuild -target "GHUnitIOS (Device)" -configuration Release
	xcodebuild -target "GHUnitIOS (Simulator)" -configuration Release
	BUILD_DIR="build" BUILD_STYLE="Release" sh ../Scripts/CombineLibs.sh
	sh ../Scripts/iOSFramework.sh

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*
xcclean:
	$(xctoolpath)xctool -sdk iphonesimulator CODE_SIGN_IDENTITY="${identity}"  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration AdHocDistribution -project $(BluesPath)Blues.xcodeproj -scheme BluesPad clean

xcbuild:
	$(xctoolpath)xctool -sdk iphonesimulator CODE_SIGN_IDENTITY="${identity}"  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration AdHocDistribution -project $(BluesPath)Blues.xcodeproj -scheme BluesPad build 

xcarchive:
	$(xctoolpath)xctool -sdk iphonesimulator CODE_SIGN_IDENTITY="${identity}"  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration AdHocDistribution -project $(BluesPath)Blues.xcodeproj -scheme BluesPad archive

xctest:
	xctool -sdk iphonesimulator -arch "i386" ONLY_ACTIVE_ARCH=NO  -configuration RELEASE  -project $(BluesPath)Blues.xcodeproj -scheme BluesPad  test

xcpackagelocal:
	xcrun  -sdk iphoneos PackageApplication -v "BluesPad.app" -o "${webserverpath}BluesPad.ipa" --sign "${identity}"

xcpackage:
	xcrun -sdk iphoneos PackageApplication -v "${BluesBuild}BluesPad.app" -o "${webserverpath}BluesPad.ipa" --sign "${identity}" --embed "${BluesBuild}${provision}"
