Ext.define('Blues.model.Widget',{
	extend: 'Ext.data.Model',

    config: {
        fields: [
        	'Id', 
        	'Name', 
        	'IsRead', 
        	'DashboardId',
        	'ContentSyntax',
        	'LayoutSyntax',
        	'SimpleShareInfo',
        	'Version'
        ],
    }
});