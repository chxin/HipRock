Ext.define('Blues.profile.Tablet',{
	extend:'Ext.app.Profile',

	config:{
		name:'tablet',
		namespace:'tablet',
		controllers:['Blues.controller.MainController'],
		views:['Blues.view.Main']
	},

	isActive:function () {
		return !Ext.os.is.Phone;
	},

	launch: function () {
		Ext.create('Blues.view.Main');
	}
});