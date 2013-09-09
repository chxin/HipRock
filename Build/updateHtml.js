(function(){
   
    var fs = require('fs');
    var file= '/Users/BuildServer/WebServer/install.html';
    var releaseType;
    var releaseVersion;
    if(process.argv.length>2){
        releaseType=process.argv[2];
        releaseVersion=process.argv[3];
        file='/Users/BuildServer/WebServer/'+process.argv[2]+'/index.html';
    }
    fs.readFile(file,{encoding:'utf8'},function(err,data){
       if(err) throw err; 
       var now = new Date();
       var str= now.getFullYear()+'/'+(now.getMonth()+1)+'/'+now.getDate();
       str+= ' '+now.getHours()+':'+now.getMinutes()+':'+now.getSeconds();
       //console.log(data);
       var newData;
       if(releaseType){
           var ul='<ul class="ul1">';
           var temple='<li class="li2">{0}:<a href="itms-services://?action=download-manifest&amp;url=http://10.177.206.47/{1}/{2}/BluesPad.plist"><span class="s1">BluesPad</span></a> Build time-{3}-</li>';
	   var newStr=temple.replace('{0}',releaseVersion).replace('{2}',releaseVersion).replace('{1}',releaseType).replace('{3}',str);
           
           newData=data.replace(ul,ul+'\n'+newStr);
       }
       else{
           newData = data.replace(/Last\sUpdated\sDateTime\:\s-(.)*-/,'Last Updated DateTime: -'+str+'-');
           console.log(newData);
       }
       fs.writeFile(file,newData,{encoding:'utf8'},function(err){
           if(err) throw err;
           console.log('success');
          
       });
       
    });
})();
