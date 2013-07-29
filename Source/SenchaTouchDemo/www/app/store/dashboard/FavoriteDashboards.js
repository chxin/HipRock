Ext.define('Blues.store.dashboard.FavoriteDashboards',{
	extend: 'Ext.data.Store',

	requires: ['Blues.model.Dashboard'],

	config: {
		model: 'Blues.model.Dashboard',
		proxy:{
	        type: 'ajax',
	        //url : 'data/Widgets.json',
	        url : Blues.config.baseUrl + 'api/dashboard.svc/getfavoritedashboards',
	        reader: {
	            type: 'json',
	        }
		}
	},
})