Ext.define('Blues.ux.widget.MagnifiedWidget',{
	extend:'Blues.ux.widget.WidgetBase',
	xtype:'magnifiedwidget',

	requires:[
		'Ext.SegmentedButton',
		'Ext.Button',
		'Blues.ux.chart.TimeRangePicker',
	],

	config:{
		style: 'background: #fff;',
	},

	initialize: function () {
		this.callParent(arguments);

		this.load();
	},

	load: function () {
		if(!this.config.data){
			var adapter = this.resolveAdapter();

			this.on('dataloaded', this.render);

			adapter.loadData(this);
		}
		else{
			this.render(this.config.data, this.config.rawData);
		}
	},

	render: function (data, rawData) {
		var me = this;

		//buttons
		var buttons = Ext.create('Ext.Container',{
			layout: 'hbox',
			margin: 20,
			items: [{
				xtype: 'segmentedbutton',
				docked: 'left',
				allowMultiple: false,
				items: [{
					text: 'Hourly',
				},{
					text: 'Daily',
					pressed: true
				},{
					text: 'Weekly',
				},{
					text: 'Monthly',
				},{
					text: 'Yearly',
				}],
			},{
				xtype: 'button',
				text: 'Time',
				width: 100,
				docked: 'right',
				listeners:{
					tap: function () {
						var picker = Ext.getCmp('timerangepicker');
						if(picker)
							picker.showBy(this);
						else
							Ext.widget('timerangepicker').showBy(this);
					}
				}
			}]
		});
		me.add(buttons);

		//chart
		var visual = Ext.widget(me.chartType+'chart',{
			style: 'margin: 40px auto 0 auto;',
			width: 900,
			height: 500,
			type: me.chartType,
			data: data,
			rawData: rawData
		});
		me.add(visual);
	}

});