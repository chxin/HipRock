Ext.define('Blues.ux.energy.DataAdapterBase',{
	//extend: 'Ext.Component',
	requires:[],

	/**
	* @abstract
	* adapter's configured optional stores
	*/
	stores: null,

	/**
	* @abstract
	* adapter's currently using store
	*/
	currentStore: null,

	/**
	* @abstract
	* adapter's raw data loaded from store
	*/
	rawData: null,

	/**
	* @abstract
	* adapter's converted data
	*/
	data: null,

	constructor:function (config) {
		this.initConfig(config);
	},

	loadData: function () {	},

    translateDate: function (datevalue, options, s) {
        var d2j = Blues.utility.date.DatetimeToJson, 
        	j2d = Blues.utility.date.JsonToDatetime;

        var start = options.start, end = options.end, step = options.step, sign = s || 1, 
            date = new Date(Ext.isNumber(datevalue) ? datevalue : j2d(datevalue)), newDate;

        switch (step) {
            case 1: //hour add 30mins
                newDate = Ext.Date.add(date, Ext.Date.MINUTE, 30 * sign);
                break;
            case 2: //day add 12hours
                newDate = Ext.Date.add(date, Ext.Date.HOUR, 12 * sign);
                break;
            case 3: //month add 15days
                newDate = Ext.Date.add(date, Ext.Date.DAY, 15 * sign);
                break;
            case 4: //2010年 add 6months
                newDate = Ext.Date.add(date, Ext.Date.MONTH, 6 * sign);
                break;
            case 5: //week add 3days&12hours
                newDate = Ext.Date.add(date, Ext.Date.DAY, 3 * sign);
                newDate = Ext.Date.add(newDate, Ext.Date.HOUR, 12 * sign);
                break;
        }

        return j2d(d2j(newDate));
    },
});