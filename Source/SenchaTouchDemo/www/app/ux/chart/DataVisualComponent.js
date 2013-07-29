Ext.define('Blues.ux.chart.DataVisualComponent',{
	extend:'Ext.Component',

	config:{
		listeners:{
			painted:function () {
				this.draw();
			}
		}
	},

	initialize: function () {
		this.callParent(arguments);
	},

	/**
	* @abstract, draw method
	*/
	draw: function () {},
});