(function(){
   
    var fs = require('fs');
    var releaseType=process.argv[2];
    var releaseVersion=process.argv[3];
    var file= '/Users/BuildServer/WebServer/'+releaseType+'/'+releaseVersion+'/BluesPad.plist';
   
    fs.readFile(file,{encoding:'utf8'},function(err,data){
       if(err) throw err; 
       var newData = data.replace('{0}',releaseVersion.substring(1));
       newData=newData.replace(/10\.177\.206\.47/g,'10.177.206.47/'+releaseType+'/'+releaseVersion);
       fs.writeFile(file,newData,{encoding:'utf8'},function(err){
           if(err) throw err;
           console.log('success');
          
       });
       
    });
})();
