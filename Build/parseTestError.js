//need node && nodemailer from npm
(function(){
var fs = require('fs');
var util=require('util');
var error=[];
var logpath='/Users/BuildServer/BuildFolder/SourceCode/Master/BluesGit/Build/'
var sendEmail=function(){
    var emailer = require('nodemailer');
    var transportOption={
        host:'10.177.1.111',
        port:25
    };
    var devs=['tan-tan.tan','feng-aries.zhang','zilong-oscar.xu'];
    var cor='@schneider-electric.com,';
    var emailOption={
        from:'Git@schneider-electric.com',
        to:devs.join(cor),
	cc:'jinhao.geng'+cor,
	subject:'UnitTest in Blues Failed!!!',
        text:'Hi guys:\n\t The following is the UT errors:\n'+error.join('\n')
    };
    var transporter=emailer.createTransport('SMTP',transportOption);
    transporter.sendMail(emailOption,function(error,respose){
        if(error){util.log(error);}
        else{ transporter.close(); }
    });
};
var filename=logpath+'testlog.json';
if(!fs.existsSync(filename)) return;
fs.readFile(filename,{encoding:'utf8'},function(err,data){
    if(err) throw err;
    var ar = data.split('\n');
    ar.forEach(function(item,idx){
        //util.log(item);
        if(item){
            var obj=JSON.parse(item);
	    if(obj['event'] && obj['event'] == 'end-test'){
	         if(obj['succeeded']==false){
	             error.push(JSON.stringify(obj));
	         }	    
	    }
        }
    });
    if(error.length>0){
 	sendEmail();
        //util.log(error.join('\n'));
    }
    
    fs.unlinkSync(filename);
    
});
})();
