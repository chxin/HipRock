Ext.define('Blues.ux.chart.ColumnChart',{
	extend:'Blues.ux.chart.TrendChart',
	alias: 'widget.columnchart',

	type: 'column',

	buildConfig: function () {
		var config = this.callParent(arguments);

		var myconfig = {
		};

		return Ext.merge(config, myconfig);
	},
});