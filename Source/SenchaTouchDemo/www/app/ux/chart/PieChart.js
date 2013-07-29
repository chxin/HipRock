Ext.define('Blues.ux.chart.PieChart',{
	extend:'Blues.ux.chart.DistributionChart',
	alias: 'widget.piechart',

	type: 'pie',

	buildConfig: function () {
		var config = this.callParent(arguments);

		var myconfig = {
		};

		return Ext.merge(config, myconfig);
	},
});