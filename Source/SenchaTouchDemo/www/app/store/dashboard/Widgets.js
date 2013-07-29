Ext.define('Blues.store.dashboard.Widgets',{
	extend: 'Ext.data.Store',

	requires: ['Blues.model.Widget'],

	config: {
		model: 'Blues.model.Widget',
		proxy:{
	        type: 'ajax',
	        url : 'data/Widgets.json',
	        //url : 'http://10.177.206.79/mobilehost/api/dashboard.svc/getfavoritedashboards',
	        reader: {
	            type: 'json',
	        }
		}
	},
})