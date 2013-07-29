Ext.define('Blues.ux.chart.LineChart',{
	extend:'Blues.ux.chart.TrendChart',
	alias: 'widget.linechart',

	type: 'line',

	buildConfig: function () {
		var config = this.callParent(arguments);

		var myconfig = {
		};

		return Ext.merge(config, myconfig);
	},
}); 