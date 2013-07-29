Ext.define('Blues.model.Dashboard',{
	extend: 'Ext.data.Model',

    config: {
        fields: [
        	'Id', 
        	'HierarchyId', 
        	'HierarchyName', 
        	'IsFavorite',
        	'IsRead',
        	'Name',
        ],
    }
});