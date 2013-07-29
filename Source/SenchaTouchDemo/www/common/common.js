/**
* @namespace Blues
* Definition of all namespaces of all common properties and methods
*/
Blues={
	/**
	* @namespace Blues.config
	* All common configurations should be in this namespace
	*/
	config:{},

	/**
	* @namespace Blues.config
	* All utility methods should be in this namespace
	*/
	utility:{},
};

/**
* @namespace Blues.config
*/
Blues.config = {
	/**
	* Base url of remote data access proxies
	*/
	baseUrl: 'http://10.177.206.79/MobileHost/',

	/**
	* Highchart default configurations
	*/
	chartDefaults: {
	    colors: [
	        '#30a0d4','#9ac350','#9d6ba4',
			'#aa9465','#74939b','#b9686e',
			'#6887c5','#8aa386','#b93d95',
			'#c2c712','#c8693f','#718b80',
			'#908d52','#3187b7','#4098a7',
	    ],
	    chart:{
	        panning: true,
	        plotBackgroundColor: null,
	        plotBorderWidth: null,
	        plotShadow: false,
	        borderRadius: 0,
	        resetZoomButton: false,
	        events: {
	        	load: function () {
                    var offset = Blues.config.chartConstants.yAxisOffset;

                    for (var i = 0, len = this.yAxis.length; i < len && i < 3; ++i) {
                        var y = this.yAxis[i], top = y.top, left = y.options.opposite ? y.left + this.plotWidth + 5 + (offset * (i - 1)) : this.options.chart.spacingLeft;

                        if (y.options.yname) {
                            var yTitle = this.renderer.text(y.options.yname, left, top).add();
                            y.yTitle = yTitle;
                        }
                    }
	        	}
	        },
	    },
		navigator:{
			enabled: false,
		},
		scrollbar:{
			enabled: false,
			liveRedraw: true,
		},
		title:{
			text:null,
		},
		rangeSelector:{
			enabled: false,
		},
		tooltip:{
			enabled: true,
			// formatter: function () {
			// 	return 'test';
			// },
			//style: 'display:none;',
		},
		credits:{
			enabled: false,
		},
	},

	/**
	* Chart constants
	*/
	chartConstants: {
		yAxisOffset: 70,
        dataLabelFormatter: function (format) {
            var f = Highcharts.numberFormat, v = Number(this.value);
            if (v < Math.pow(10, 3) && v != 0) {
                if (format === false) {
                    return v;
                }
                else {
                    return f(v, 2);
                }
            }
            else if (v < Math.pow(10, 6)) {
                if (format === false) {
                    return v;
                }
                else {
                    return f(v, 0);
                }
            }
            else if (v < Math.pow(10, 8)) {
                v = f(parseInt(v / Math.pow(10, 3)), 0) + 'k';
            }
            else if (v < Math.pow(10, 11)) {
                v = f(parseInt(v / Math.pow(10, 6)), 0) + 'M';
            }
            else if (v < Math.pow(10, 14)) {
                v = f(parseInt(v / Math.pow(10, 9)), 0) + 'G';
            }
            else if (v < Math.pow(10, 17)) {
                v = f(parseInt(v / Math.pow(10, 12)), 0) + 'T';
            }
            return v;
        }
	}
};

/**
* @namespace Blues.utility
*/
Blues.utility = {
	/**
	* @namespace Blues.utility.date
	*/
	date: {
		/**
		* @property, time constants
		*/
	    FixedTimes: {
	        millisecond: 1,
	        second: 1000,
	        minute: 60 * 1000,
	        hour: 3600 * 1000,
	        day: 24 * 3600 * 1000,
	        week: 7 * 24 * 3600 * 1000,
	        month: 31 * 24 * 3600 * 1000,
	        year: 366 * 24 * 3600 * 1000
	    },

		/**
		* @property, time level constants
		*/
    	TimeLevel: ['millisecond', 'second', 'minute', 'hour', 'day', 'week', 'month', 'year'],

	    IsValidDate: function (date) {
	        if (typeof (date) === 'number') {
	            var earliest = new Date(2000, 0, 1).getTime();
	            var now = new Date().getTime();
	            return date >= earliest && date <= now;
	        }
	        else return date && date.getTime && (date >= new Date(2000, 0, 1)) && (date <= new Date());
	    },

		RoundDate: function (date) {
		    if (this.IsValidDate(date)) {
		        var floor, ceil;
		        date = typeof (date) === 'number' ? new Date(date) : date;

		        floor = new Date(date.getTime());
		        floor.setHours(0);
		        floor.setMinutes(0);
		        floor.setSeconds(0);
		        floor.setMilliseconds(0);

		        ceil = Ext.Date.add(floor, Ext.Date.DAY, 1);

		        var floordistance = Math.abs(floor.getTime() - date.getTime());
		        var ceildistance = Math.abs(ceil.getTime() - date.getTime());

		        return floordistance < ceildistance ? floor : ceil;
		    }
		},

		DatetimeToJson: function (datetime) {
	        var timezoneoffset = new Date().getTimezoneOffset() * 60000;
	        var l = datetime.getTime() - timezoneoffset;
	        return '\/Date(' + l + ')\/';
	    },

	    JsonToDateTime: function (jsonstring, outintval) {
	        outintval = typeof (outintval) === 'boolean' ? outintval : true;
	        jsonstring = jsonstring.substr(6, jsonstring.length - 8);

	        var timezoneoffset = new Date().getTimezoneOffset() * 60000;
	        var mydate;
	        if (outintval) {
	            mydate = parseInt(jsonstring) + timezoneoffset;
	        }
	        else {
	            mydate = parseInt(jsonstring) + timezoneoffset;
	            mydate = eval('new Date(' + mydate + ')');
	            mydate && mydate.getYear && (mydate = Ext.Date.format(mydate, 'Y-m-d H:i:s'));
	        }

	        return mydate;
	    },

	    FormatDateByStep: function (time, start, end, step) {
	        var date = new Date(time),
	            ft = I18N.DateTimeFormat.IntervalFormat,
	            eft = Ext.Date.format,
	            str = '', extDate = Ext.Date,
	            add = extDate.add, newDate;
	        switch (step) {
	            case 1: //hour 2010年10月3日0点-1点
	                //     2010年10月3日23点-3日24点
	                {
	                    str = eft(date, ft.FullHour);
	                    newDate = add(date, extDate.HOUR, 1);
	                    if (newDate.getHours() < date.getHours()) {//2010年10月3日23点-3日24点
	                        str += '-' + I18N.EM.Clock24/*'24点'*/;
	                    }
	                    else {// 2010年10月3日0点-1点
	                        str += '-' + eft(newDate, ft.Hour);
	                    }

	                    break;
	                }
	            case 2: //day 2010年10月3日
	                {
	                    str = eft(date, ft.FullDay);
	                    break;
	                }
	            case 3: //month 2010年10月
	                {
	                    str = eft(date, ft.Month);
	                    break;
	                }
	            case 4: //2010年
	                {
	                    str = eft(date, ft.Year);
	                    break;
	                }
	            case 5: //week 2010年10月3日-10日,2010年10月29日-11月5日,2010年12月29日-2011年1月5日
	                {
	                    date = add(date, extDate.DAY, 0 - date.getDay() + 1);
	                    str = eft(date, ft.FullDay);
	                    newDate = add(date, extDate.DAY, 6);
	                    if (newDate.getFullYear() > date.getFullYear()) {
	                        //2010年12月29日-2011年1月5日
	                        str += '-' + eft(newDate, ft.FullDay);
	                    }
	                    else if (newDate.getMonth() > date.getMonth()) {
	                        //2010年10月29日-11月5日
	                        str += '-' + eft(newDate, ft.MonthDate);
	                    }
	                    else {
	                        //2010年10月3日-10日
	                        str += '-' + eft(newDate, ft.Day);
	                    }
	                    break;
	                }
	        }
	        return str;
	    },

	    GetInterval: function (start, end) {
	        if (end < start) return;
	        var ft = this.FixedTimes;
	        var lvs = [];
	        lvs.push(ft.day); // 1day
	        lvs.push(ft.week); //1week
	        lvs.push(31 * ft.day); //1month 31day
	        lvs.push(31 * 3 * ft.day); //3month 93day
	        lvs.push(ft.year); // 1year
	        lvs.push(2 * ft.year); // 2year
	        lvs.push(10 * ft.year); // 5year

	        var diff = end - start;
	        var interval = {};
	        var i;
	        for (i = 0; i < lvs.length; i++) {
	            if (diff <= lvs[i]) {
	                break;
	            }
	        }
	        var list = [], display, gridList = [];
	        //1-Hourly,2-Daily,3-Monthly,4-Yearly,5-Weekly
	        switch (i) {
	            case 0: //<=1day
	                list = [1];//can hour  
	                gridList = [1];//can hour  
	                display = 1; //default hour
	                break;
	            case 1: //<=1week
	                list = [1, 2]; //can hour & day 
	                gridList = [1, 2]; //can hour & day 
	                display = 2; //default day
	                break;
	            case 2: //<=1month
	                list = [2, 5]; //can  day & week 
	                gridList = [1, 2, 5];//can  hour & day & week 
	                display = 2; //default day
	                break;
	            case 3: //<=3month
	                list = [2, 3, 5]; //can  day & week & month
	                gridList = [1, 2, 3, 5];//can  hour & day & week & month
	                display = 3; //default month
	                break;
	            case 4: //<=1year
	                list = [3]; //can  month 
	                gridList = [1, 2, 3, 5];//can  hour & day & week & month
	                display = 3; //default month
	                break;
	            case 5: //<=2year
	                list = [3, 4]; //can  month & year
	                gridList = [1, 2, 3, 4, 5];//can  hour & day & week & month & year
	                display = 3; //default month
	                break;
	            case 6://<=10year
	                list = [3, 4]; //can  month & year
	                gridList = [2, 3, 4, 5];//can day & week & month & year
	                display = 3; //default month
	                break;
	        }
	        interval.list = list;
	        interval.display = display;
	        interval.gridList = gridList;
	        return interval;

	    },

	    GetIntervalByElapsed: function (elapsed) {
	        return this.GetInterval(0, elapsed);
	    },

	    GetZoomLevel: function (datemin, datemax) {
	        var lvs = [];
	        lvs.push(this.FixedTimes.day);
	        lvs.push(this.FixedTimes.week);
	        lvs.push(this.FixedTimes.month);
	        lvs.push(this.FixedTimes.year);
	        lvs.push(2 * this.FixedTimes.year);
	        lvs.push(5 * this.FixedTimes.year);

	        var datedistance = datemax - datemin;
	        var i;
	        for (i = 0; i < lvs.length; i++) {
	            if (datedistance <= lvs[i]) {
	                return i;
	            }
	        }
	        return i;
	    },

	    Add: function (rdate, count, level) {
	        if (Ext.Array.contains(this.TimeLevel, level) && this.IsValidDate(rdate)) {
	            switch (level) {
	                case 'millisecond':
	                case 'second':
	                case 'minute':
	                case 'hour':
	                case 'day':
	                case 'week':
	                    return (rdate + count * eval('REM.utility.date.FixedTimes.' + level));
	                    break;
	                case 'month':
	                    return Ext.Date.add(new Date(rdate), Ext.Date.MONTH, count).getTime();
	                    break;
	                case 'year':
	                    return Ext.Date.add(new Date(rdate), Ext.Date.YEAR, count).getTime();
	                    break;
	            }

	        }
	        throw 'unexpected args';
	    },

	    Subtract: function (rdate, count, level) {
	        if (Ext.Array.contains(this.TimeLevel, level) && this.IsValidDate(rdate)) {
	            switch (level) {
	                case 'millisecond':
	                case 'second':
	                case 'minute':
	                case 'hour':
	                case 'day':
	                case 'week':
	                    return (rdate - count * eval('REM.utility.date.FixedTimes.' + level));
	                    break;
	                case 'month':
	                    return Ext.Date.add(new Date(rdate), Ext.Date.MONTH, -count).getTime();
	                    break;
	                case 'year':
	                    return Ext.Date.add(new Date(rdate), Ext.Date.YEAR, -count).getTime();
	                    break;
	            }

	        }
	        throw 'unexpected args';
	    },

	    Distance: function (datea, dateb) {
	        return datea - dateb;
	    },

	    Compare: function (datea, dateb) {
	        if (datea === dateb) return 0;
	        return datea > dateb;
	    },

	    AddStep: function (time, step) {
	        var ticks = time - 0;
	        switch (step) {
	            case 1: //hourly, add one hour, this is a fixed value
	                return new Date(ticks + this.FixedTimes.hour);
	            case 2: //daily, add one day, this is a fixed value
	                return new Date(ticks + this.FixedTimes.day);
	            case 5: //weekly, add one week, this is a fixed value
	                return new Date(ticks + this.FixedTimes.week);
	            case 3: //monthly, add one month, this is not a fixed value, need construct
	                var year = time.getFullYear(), month = time.getMonth(), totalMonths = year * 12 + month + 1;
	                var newtime = new Date(Math.floor(totalMonths / 12), totalMonths % 12, 1, 0, 0, 0, 0);
	                return new Date(newtime - (newtime.getTimezoneOffset() * 60000));
	            case 4: //yearly, add one year, this is not a fixed value, need construct
	                var newtime = new Date(time.getFullYear() + 1, 0, 1, 0, 0, 0, 0);
	                return new Date(newtime - (newtime.getTimezoneOffset() * 60000));
	        }
	    }
	},

	/**
	* @namespace Blues.utility.data
	*/
	data: {

	},

	/**
	* @namespace Blues.utility.string
	*/
	string: {
		startsWith: function (str, partial) {
			return str.length>partial.length && str.substr(0,partial.length)==partial;
		},
		endsWith: function (str, partial) {
			return str.length>partial.length && str.substr(str.length-partial.length);
		},
	},

}
