Ext.define('Blues.view.dashboard.WidgetList',{
	extend:'Ext.Container',
	xtype:'widgetlist',

	requires:['Blues.ux.widget.ThumbnailWidget','Blues.store.dashboard.FavoriteDashboards'],

	config:{
		padding: '0 10',
		style: 'background:#fff;',
		scrollable:{
			direction: 'vertical',
			directionLock: true,
		},
	},

	initialize: function () {
		this.callParent(arguments);

		//event listeners
		this.on('resize', this.reorderWidgets);
		this.on('widgetsloaded', this.renderWidgets);

		this.loadData();
	},

	loadData:function () {
		var me = this, store = Ext.create('Blues.store.dashboard.Widgets');

		store.load({
			callback: function (records,operation,success) {
				if(success){
					this.fireEvent('widgetsloaded',records);
				}
			},
			scope:this,
		});
	},

	renderWidgets: function (widgets) {
		for(var i=0; i<widgets.length; i++){
			var widget = widgets[i].data;

			window.setTime

			this.add(Ext.create('Blues.ux.widget.ThumbnailWidget',{
				model: widget,
			}));
		}
	},

	reorderWidgets: function (self,options) {
		var padding = options.width > 2*380 ? '0 10' : '0 80';

		this.setPadding(padding);
	},
});