Ext.define('Blues.view.dashboard.WidgetDetail',{
	extend:'Ext.Panel',
	alias:'widget.widgetdetail',

	requires:[],

	config:{
		fullscreen: true,
		layout:'hbox',
		items:[{
			//id: 'widgetdetail-toolbar',
            docked: 'top',
            xtype: 'titlebar',
			title: 'Widget',
			height: 46,
			items:[{
				id: 'widgetdetail-back',
				text: 'Back',
				ui: 'back',
				ailgn: 'left',
			},{
				id: 'widgetdetail-reply',
				iconCls: 'reply',
				align: 'right',
			},{
				id: 'widgetdetail-compose',
				iconCls: 'compose',
				align: 'right',
			},{
				id: 'widgetdetail-trash',
				iconCls: 'trash',
				align: 'right',
			}],
		}],
	},

	initialize: function () {
		this.callParent(arguments);

		this.render();
	},

	render: function (argument) {
		var me = this;

		//this.renderToolbar();
		me.down('titlebar').setTitle(this.config.model.Name);
		me.down('#widgetdetail-back').on({
			scope: this,
			tap: me.close,
		});

		//this.renderMagnifiedWidget();
		var widget = Ext.create('Blues.ux.widget.MagnifiedWidget',{
			flex: 1,
			model: this.config.model,
			data: this.config.data,
			rawData: this.config.rawData,
		});
		this.add(widget);
	},

	close:function () {
		this.hide();
		this.destroy();
	},

});