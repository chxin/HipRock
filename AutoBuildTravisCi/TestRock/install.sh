OUTPUTDIR="./build"
APPNAME="TestRock"
SCHEME="TestRock_Test"
APP_PROJECTPACE="./TestRock.xcodeproj"

# rm "$OUTPUTDIR/$APPNAME.ipa" #deletes previous ipa
# xcodebuild -project "$APP_PROJECTPACE" -scheme "$SCHEME" archive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -quiet
# xcodebuild -exportArchive -archivePath "$OUTPUTDIR/$APPNAME.xcarchive" -exportPath "$OUTPUTDIR/$APPNAME" -exportOptionsPlist "exportOptions.plist" -quiet

# HTTP_URL='https://qiniu-storage.pgyer.com/apiv1/app/upload'
#
# filePath=$OUTPUTDIR/$APPNAME/$SCHEME.ipa
# echo "filename=@${filePath}"
# curl -F "User-Agent=Mozilla/5.0,Referer=@{HTTP_URL},_api_key=aa" -F "filename=@${filePath}" $HTTP_URL -x 101.231.121.17:80

UPLOAD_SERVER=https://qiniu-storage.pgyer.com/apiv1/app/upload
filePath=$OUTPUTDIR/$APPNAME/$SCHEME.ipa
upload(){
        #先判断要上传的文件是否存在
        if [ -f ${1} ];then
                file=${1}
# curl -F uKey=24af41e3b5e5117e773a733378aefa29 _api_key=0691c7489e57a5158796f6e1e7e988bd file=@${filePath} installType=1 $UPLOAD_SERVER -x 10.177.122.238:8888
curl -i -X POST -H Content-Type:application/json -H User-Agent:Mozilla/5.0 -d '{"uKey":"24af41e3b5e5117e773a733378aefa29","_api_key":"0691c7489e57a5158796f6e1e7e988bd","file":@${filePath},"installType":"1"}' $UPLOAD_SERVER -x localhost:8888
#curl -H "enctype:'multipart/form-data';Content-type: application/json" -X POST -d '{"uKey":"24af41e3b5e5117e773a733378aefa29","_api_key":"0691c7489e57a5158796f6e1e7e988bd","file":$filePath,"installType":1}' UPLOAD_SERVER -x 101.231.121.17:80

                # curl -s --header "Content-Type:multipart/form-data" --form "files[]=@${file}" UPLOAD_SERVER
                return 0
        else
                return 1
        fi
}

resolv_json(){
        #解析JSON
        JSON=${1}
        ATTRIBUTE=${2}
        echo ${JSON} | grep -Po \"${ATTRIBUTE}\":\".*?\" | awk -F \" '{print $4}'
}

json=$(upload $filePath)
if [ $? == 0 ];then
        echo Upload Server : ${UPLOAD_SERVER}
        for i in realName niceSize fileKey
        do
                echo ${i} : $(resolv_json "'${json}'" ${i})
        done
else
        echo 'File Not Exis!'
fi
