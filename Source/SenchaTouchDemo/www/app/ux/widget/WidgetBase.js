Ext.define('Blues.ux.widget.WidgetBase',{
	extend:'Ext.Container',

	requires:[
		'Ext.Component',
		'Blues.ux.chart.ChartComponent',
		'Blues.ux.energy.TagDataAdapter',
		'Blues.view.dashboard.WidgetDetail'
	],

	/**
	* @property, widget title
	*/
	title: '',

	/**
	* @property, query parameter
	*/
	queryParameter: null,

	/**
	* @property, module
	* optional values: 'tag','carbon','cost','unit','ratio','ranking'
	*/
	module: '',

	/**
	* @property, data option
	* optional values: trend or distribute
	*/
	dataType: '', 

	/**
	* @property, chartType
	* optional values: 'line','column','pie','stack','grid'
	*/
	chartType: '', 

	initialize: function (argument) {
		this.callParent(arguments);

        this.initializeProperty();
	},

	initializeProperty: function () {
		if(this.config.model){ // if model set, use model to resolve widgetType, chartType, parameters, 
			var syntax = Ext.decode(this.config.model.ContentSyntax);
		
			this.title = this.config.model.Name;
			this.resolveSyntax(syntax);
		}
		else{ // if model not set, use the configs
			this.queryParameter = this.config.queryParameter;
			this.module = this.config.module;
			this.chartType = this.config.chartType;
			this.dataType = this.config.dataType;
		}
	},

	resolveSyntax: function (syntax) {
		var dictionary = {
			//tag
			'energy.Energy': {module: 'tag',dataType: 'trend' },
			'energy.Distribute': { module: 'tag',dataType: 'distribute' },
			//carbon
			'energy.CarbonUsage': { module: 'carbon',dataType: 'trend' },
			'energy.CarbonDistribution': { module: 'carbon',dataType: 'distribute' },
		};
		var dataOption = dictionary[syntax.params.config.storeType];

		this.queryParameter = syntax.params.submitParams;
		this.module = dataOption.module;
		this.dataType = dataOption.dataType;
		this.chartType = syntax.params.config.type;
	},

	resolveAdapter: function () {
		return Ext.create('Blues.ux.energy.TagDataAdapter',{
			params: this.queryParameter,
			module: this.module,
			dataType: this.dataType,
		});
	},
});