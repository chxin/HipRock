projectpath:=Trunk/Src/Blues.xcodeproj
scheme:=Blues
#BluesBuild:=/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/
xctoolpath:=/Users/buildserver/BuildFolder/Tools/xctool/bin/
#webserverpath:=/Users/BuildServer/WebServer/
#identity:=iPhone Distribution:cn.com.schneider-electric.BluesPad
#identity:=iPhone Distribution: Schneider Electric (China) Investment Co., Ltd. (46REERL7A3)
#provision:=Blues_AdHoc.mobileprovision

xcclean:
	$(xctoolpath)xctool -project ${PROJECTDIR}$(projectpath) -scheme $(scheme) clean

xcbuild:
	$(xctoolpath)xctool -project ${PROJECTDIR}${projectpath} -scheme $(scheme) -configuration ${BUILDTYPE} CONFIGURATION_BUILD_DIR=${OUTPUTDIR} -sdk=7.0 -jobs=1 ONLY_ACTIVE_ARCH=NO SDKROOT=iphoneos7.0 build 

xctest:
	$(xctoolpath)xctool -sdk iphonesimulator  ONLY_ACTIVE_ARCH=NO  -configuration Debug  -project $(BluesPath)Blues.xcodeproj -scheme CommonTests  test -test-sdk iphonesimulator -freshInstall -freshSimulator -reporter json-stream:testlog.json  

xctestcommand:
	$(xctoolpath)xctool -sdk iphonesimulator  ONLY_ACTIVE_ARCH=NO  -configuration Debug  -project $(BluesPath)Blues.xcodeproj -scheme CommonTests  test -test-sdk iphonesimulator -freshInstall -freshSimulator

#parameters: apppath, ipapath
xcpackage:
	xcrun -sdk iphoneos PackageApplication  "${apppath}" -o "${ipapath}"
