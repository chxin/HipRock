Ext.define('Blues.ux.data.WrappedMessageReader', {
    extend: 'Ext.data.JsonReader',
    alias: 'reader.wcfjson',

    // constructor: function (config) {
    //     this.initConfig(config);
    // },

    getDataItem: function (dataItem, response) {
        return dataItem;
    },

    getResponseData: function (response) {
        //var rptxt = '{ "GetVTagsBySystemDimensionResult": [{ "Id": 1, "Name": "VTAGNAME001"}], "errorCode": "0" }';
        var me = this;
        var data = Ext.decode(response.responseText);
        var total = data.total;
        var errorCode = '';//data.error.Code;
        var action = response.request.options.operation.action;
        var requestURL = response.request.options.url;
        var root = requestURL.substr(requestURL.lastIndexOf('/') + 1, requestURL.lastIndexOf('?') > 0 ? requestURL.lastIndexOf('?') - requestURL.lastIndexOf('/') - 1 : undefined) + 'Result';
        var i = 0;
        var dataItem;

        delete data.error;

        data = data[root];

        response.errorCode = errorCode;

        if (errorCode == 0) {
            if (data != null) {
                if (action == 'create') {
                    data = [me.getDataItem(data, response)];
                } else if (action == 'read' || action == 'update') {
                    if (Ext.isArray(data)) {
                        for (i = 0; i < data.length; i++) {
                            dataItem = me.getDataItem(data[i], response);
                            data[i] = dataItem;
                        }
                    } else {
                        data = me.getDataItem(data, response);
                    }
                } else if (action == 'destroy') {
                    data = new Array();
                } else {
                    if (Ext.isArray(data)) {
                        for (i = 0; i < data.length; i++) {
                            dataItem = me.getDataItem(data[i], response);
                            data[i] = dataItem;
                        }
                    } else {
                        data = me.getDataItem(data, response);
                    }
                }
            } else {
                data = [];
            }
            data[this.successProperty] = true;
        }
        else {
            Blues.application.handleError(response, errorCode);
            data = [];
            data[this.successProperty] = false;
        }
        if (total && Ext.isNumber(total)) {
            data = {
                data: data,
                total: total
            }
            this.root = 'data';
        }
        return me.readRecords(data);
    }
});