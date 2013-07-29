Ext.define('Blues.view.layout.NavigationView',{
	extend: 'Ext.Container',
	xtype:'navigationview',

	requires:['Ext.Toolbar','Ext.field.Search','Ext.dataview.List'],

	config:{
		layout:'vbox',

		items:[{
			docked:'top',
			xtype:'toolbar',
			height: 46,
			items:[{
				xtype:'searchfield',
				width:180,
				placeHolder:'Search',
				name:'navigationsearch',
			}]
		},{
			flex:1,
			xtype:'list',
			itemTpl:'{title}',
			data:[
				{title:'Customer'},
				{title:'User'},
				{title:'Favorite'},
				{title:'All'},
				{title:'Recent'}
			]
		}],

		style: 'border-right:1px solid black',
	},

	initialize: function () {
		this.callParent(arguments);


	}

});

