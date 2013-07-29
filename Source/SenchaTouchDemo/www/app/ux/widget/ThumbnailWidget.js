Ext.define('Blues.ux.widget.ThumbnailWidget',{
	extend:'Blues.ux.widget.WidgetBase',
	xtype:'thumbnailwidget',

	requires:[
		'Ext.Anim',
		'Blues.ux.energy.TagDataAdapter',
		'Blues.ux.chart.LineChart',
		'Blues.ux.chart.ColumnChart',
		'Blues.ux.chart.PieChart',
	],

	config:{
		height: '240',
		width: '380',
		margin: 10,
		style: 'border: 1px solid #eee; float:left; width:380px; height: 240px; background:#fff;',
	},

	initialize: function () {
		this.callParent(arguments);

		this.on('dataloaded', this.render);

		this.load();
	},

	load: function () {
		//resolve data adapter
		var adapter = this.resolveAdapter();

		adapter.loadData(this);
	},

	render: function (data, rawData) {
		var me = this;

		// render title
		var title = Ext.create('Ext.Component', {
			html: me.config.model.Name,
			margin: 5,
			style: 'font-size:14px;',
		})
		title.element.on({'tap' : function () {
			//open large widget view
			Ext.widget('widgetdetail',{
				model: me.config.model,
				data: data,
				rawData: rawData
			}).show('slideIn');
		}});
		me.add(title);

		//render data visualization component
		var visual = Ext.widget(me.chartType+'chart',{
			margin: '10px 5px 5px 5px',
			width: 370,
			height: 205,
			data: data,
			rawData: rawData
		});
		me.add(visual);

	},

});