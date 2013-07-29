Ext.define('Blues.ux.energy.TagDataAdapter',{
	extend: 'Blues.ux.energy.DataAdapterBase',
	xtype: 'tagdataadapter',

	requires: [
		'Ext.data.Store',
		'Blues.ux.energy.DataAdapterBase',
		'Blues.store.energy.TagsUsage',
		'Blues.store.energy.TagsDistribute',
	],

	stores: {
		'trend': Ext.create('Blues.store.energy.TagsUsage')
		/*Ext.create('Ext.data.Store',{
			data: (function () {
				var baseDate = new Date(2012,0,1,0,0,0,0);
				var data = [{
					TargetEnergyData: [{
						Target:{
							TargetId: 1175,
							Name: 'V0',
							Code: 'V0',
							UomId: 1,
							Uom: 'KWH',
							CommodityId: 1,
							StartTime: '/Date('+(baseDate-0)+')/',
							EndTime: '/Date('+(Ext.Date.add(baseDate,Ext.Date.DAY, 7)-0)+')/',
							TimeSpan: {
								StartTime: '/Date('+(baseDate-0)+')/',
								EndTime: '/Date('+(Ext.Date.add(baseDate,Ext.Date.DAY, 7)-0)+')/',
							},
							Type: 1,
						},
						EnergyData:[],
					}],
					NavigatorData: {},
					Calendars: [],
				}];

				for(var i=0;i<90;i++){
					data[0].TargetEnergyData[0].EnergyData.push({
						LocalTime: '/Date('+(Ext.Date.add(baseDate,Ext.Date.DAY, i)-0)+')/',
						DataValue: Math.floor(Math.random()*8000),
						DataQuality: 0,
					});
				}
				return data;
			})(),
		})*/,
		'distribute': Ext.create('Blues.store.energy.TagsDistribute')
		/*Ext.create('Ext.data.Store',{
			data: (function () {
				var data = [{
					TargetEnergyData: [],
					NavigatorData: {},
					Calendars: [],
				}];

				for(var i=0;i<3;i++){
					data[0].TargetEnergyData.push({
						Target:{
							Name: 'A'+i,
						},
						EnergyData:[{
							LocalTime: i,
							DataValue: Math.floor(Math.random()*10),
							DataQuality: 0,
						}]
					});
				}
				return data;
			})(),
		})*/,
	},

	loadData: function (widgetComponent) {
		var me = this, parameters = widgetComponent.queryParameter;

		me.getStore().load({
			scope: this,
			params: parameters,
			callback: function (records,operation,success) {
				var rawData = records[0].raw._records;
				var data = me.adapt(rawData);

				widgetComponent.fireEvent('dataloaded', data, rawData);
			},
		});
	},

	getStore: function () {
		return this.stores[this.config.dataType];
	},

	adapt: function (rawData) {
		//debugger;
		var data = [];
		if(!rawData)
			return data;
		if(!rawData.length || rawData.length<=0)
			return data;
		
		rawData = rawData[0].data; //remove when fix ajax call

		var dateutil = Blues.utility.date;
		var energy = rawData.TargetEnergyData;

		if(this.config.dataType=='trend'){
			for(var i=0;i<energy.length;i++){
				var targetEnergyData = energy[i], seriesData = [];

				for(var j=0;j<targetEnergyData.EnergyData.length;j++){
					var point = targetEnergyData.EnergyData[j];
					seriesData.push([dateutil.JsonToDateTime(point.LocalTime,true), point.DataValue] );
				}

				data.push({
					name: targetEnergyData.Target.Name,
					yname: targetEnergyData.Target.Uom,
					xmin: dateutil.JsonToDateTime(targetEnergyData.Target.TimeSpan.StartTime,true),
					xmax: dateutil.JsonToDateTime(targetEnergyData.Target.TimeSpan.EndTime,true),
					data: seriesData,
				});
			}
		}
		else{
			var seriesData = [];
			for(var i=0;i<energy.length;i++){
				var targetEnergyData = energy[i], point = targetEnergyData.EnergyData[0];

				seriesData.push([targetEnergyData.Target.Name, point.DataValue]);
			}

			data.push({
				data: seriesData,
			});
		}

		return data;
	},
});