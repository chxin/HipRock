xcodebuild -project "./ios/learnRN.xcodeproj" -scheme "learnRN" archive -archivePath "./buildIOSTemp/learnRN_0.0.1.xcarchive" -quiet
xcodebuild -exportArchive -archivePath "./buildIOSTemp/learnRN_0.0.1.xcarchive" -exportPath "./buildIOSTemp/learnRN_0.0.1" -exportOptionsPlist "exportTestOptions.plist" -quiet
