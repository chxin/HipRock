Ext.define('Blues.ux.chart.DistributionChart',{
	extend: 'Blues.ux.chart.ChartComponent',

	buildConfig: function () {
		var config = this.callParent(arguments);

		var myconfig = {
			series: this.buildSeries(),
		};

		return Ext.merge(config, myconfig);
	},

	buildSeries: function () {
		var me = this, series = [];

		for(var i=0;i<me.config.data.length;i++){
			var seriesItem = Ext.clone(me.config.data[i]);

			//add series settins

			series.push(seriesItem);
		}
		return series;
	},
});