BluesPath:=../Trunk/Src/
BluesBuild:=~/BuildFolder/SourceCode/Master/BluesGit/Build/
xctoolpath:=~/BuildFolder/Tools/xctool/bin/
default:
	xcodebuild -target "GHUnitIOS (Device)" -configuration Release
	xcodebuild -target "GHUnitIOS (Simulator)" -configuration Release
	BUILD_DIR="build" BUILD_STYLE="Release" sh ../Scripts/CombineLibs.sh
	sh ../Scripts/iOSFramework.sh

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

xcbuild:
	$(xctoolpath)xctool -sdk iphonesimulator  CONFIGURATION_BUILD_DIR=$(BluesBuild)  ONLY_ACTIVE_ARCH=NO -configuration RELEASE -project $(BluesPath)Blues.xcodeproj -scheme BluesPad build 

xctest:
	xctool -sdk iphonesimulator -arch "i386" ONLY_ACTIVE_ARCH=NO  -configuration RELEASE  -project $(BluesPath)Blues.xcodeproj -scheme BluesPad  test
