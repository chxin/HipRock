Ext.define('Blues.ux.data.XsStore',{
	extend: 'Ext.data.Store',

	constructor: function (config) {
		this.initConfig(config);
		//set url
		if(this.config.proxy && this.config.proxy.url){
			if(!Blues.utility.string.startsWith(this.config.proxy.url,'http://'))
				this.config.proxy.url = Blues.config.baseUrl + this.config.proxy.url;
		}
	}






















});