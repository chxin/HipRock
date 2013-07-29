Ext.define('Blues.store.energy.TagsUsage',{
	extend: 'Ext.data.Store',

	requires: [
		'Blues.model.Energy',
		'Blues.ux.data.XsProxy',
		'Blues.ux.data.WrappedMessageReader'
	],

	config: {
		model: 'Blues.model.Energy',
		proxy: {
			type: 'xsproxy',
			api: {
				read: Blues.config.baseUrl + 'api/Energy.svc/GetTagsData',
			},
			reader: 'wcfjson',
        	useDefaultXhrHeader: false,
		}
	}
});