Ext.define('Blues.view.layout.ContentView',{
	extend:'Ext.Container',
	xtype:'contentview',

	requires:['Ext.TitleBar','Blues.view.dashboard.WidgetList'],

	config:{
		layout:'hbox',

		items: [{
            docked: 'top',
            xtype: 'titlebar',
			title: 'Dashboard',
			height: 46,
			items:[{
				iconCls: 'reply',
				align: 'right',
			},{
				iconCls: 'trash',
				align: 'right',
			},{
				iconCls: 'star',
				align: 'right',
			}],
        },{
        	xtype: 'widgetlist',
        	flex: 1
        }]
	},
});