(function(){
    var fs = require('fs');
    var file= '/Users/BuildServer/WebServer/install.html';
    fs.readFile(file,{encoding:'utf8'},function(err,data){
       if(err) throw err; 
       var now = new Date();
       var str= now.getFullYear()+'/'+(now.getMonth()+1)+'/'+now.getDate();
       str+= ' '+now.getHours()+':'+now.getMinutes()+':'+now.getSeconds();
       //console.log(data);
      
       var newData = data.replace(/Last\sUpdated\sDateTime\:\s-(.)*-/,'Last Updated DateTime: -'+str+'-');
console.log(newData);
       fs.writeFile(file,newData,{encoding:'utf8'},function(err){
           if(err) throw err;
           console.log('success');
          
       });
       
    });
})();
