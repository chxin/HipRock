Ext.define('Blues.ux.chart.ChartComponent',{
	extend:'Blues.ux.chart.DataVisualComponent',

	/**
	* @property, highchart default configurations
	*/
	defaults: Blues.config.chartDefaults,

	/**
	* @property, chart type
	* optional values: 'line', 'column', 'pie', 'stack'
	*/
	type: '', 

	initialize: function () {
		this.callParent(arguments);
	},

	draw: function () {
		var config = Ext.merge({}, this.defaults, this.buildConfig());

		new Highcharts.StockChart(config);
	},

	buildConfig: function () {
		return {
			chart: {
				renderTo: this.getId(),
				type: this.type,
			}
		};
	},
});