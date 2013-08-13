(function(){
var util=require('util');
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
        subject:'Build in Blues Failed!!!',
        text:'Hi guys:\n\t Build Error, plz check'
    };
    var transporter=emailer.createTransport('SMTP',transportOption);
    transporter.sendMail(emailOption,function(error,respose){
        if(error){util.log(error);}
        else{ transporter.close(); }
    });
};
sendEmail();
})();
