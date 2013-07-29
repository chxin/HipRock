Ext.define('Blues.ux.chart.TrendChart',{
	extend: 'Blues.ux.chart.ChartComponent',

	buildConfig: function () {
		var config = this.callParent(arguments);

		var myconfig = {
			xAxis: {
				dateTimeLabelFormats: {
					day: "%m月%d日",
					dayhour: "%m月%d日%H点",
					fullmonth: "%Y年%m月",
					hour: "%H点",
					millisecond: "%H点%M分%S秒%L毫秒",
					minute: "%H点%M分",
					month: "%m月",
					second: "%H点%M分%S秒",
					week: "%m月%d日",
					year: "%Y年",
				},
				type: 'datetime',
				labels: {
					overflow: 'justify'
				},
				tickLength: 0,
				min: this.config.data[0].xmin,
				max: this.config.data[0].xmax,
			},
			yAxis: this.buildYAxis(),
			series: this.buildSeries(),
		};

		return Ext.merge(config, myconfig);
	},

	buildYAxis: function () {
		var yAxis = [];

		for(var i=0;i<this.config.data.length;i++){
			var seriesItem = Ext.clone(this.config.data[i]);

			yAxis.push({
				formatter: Blues.config.chartConstants.dataLabelFormatter,
				type: 'linear',
				min: 0,
				offset: 0,
				yname: seriesItem.yname,
				title: {
					align: 'high',
					rotation: 0,
					text: '',
					y: -15
				},
				labels: {
					align: 'right',
					x: -6,
					y: 5
				},
			});
		}

		return yAxis;
	},

	buildSeries: function () {
		var me = this, series = [];

		for(var i=0;i<me.config.data.length;i++){
			var seriesItem = Ext.clone(me.config.data[i]);

			//add series settings

			series.push(seriesItem);
		}
		return series;
	},
});