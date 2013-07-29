Ext.define('Blues.store.energy.TagsDistribute',{
	extend: 'Ext.data.Store',

	requires: [
		'Blues.model.Energy',
		'Blues.ux.data.XsProxy',
		'Blues.ux.data.WrappedMessageReader'
	],

	config: {
		model: 'Blues.model.Energy',
		proxy: {
	        type: 'ajax',
	        api: {
	        	read: Blues.config.baseUrl + 'api/Energy.svc/AggregateTagsData',
	        },
	        reader: 'wcfjson'
		}
	}
});