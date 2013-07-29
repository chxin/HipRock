Ext.define('Blues.ux.data.XsProxy',{
	extend:'Ext.data.proxy.Ajax',
	alias:'proxy.xsproxy',

	requires:['Ext.data.proxy.Ajax'],

    config: {
        sortParam: 'sorters',
        simpleSortMode: false,
        timeout: 600000,
        reader: 'wcfjson',
        useDefaultXhrHeader: false, //set to false to make CORS requests
    },

    actionMethods: {
        create: 'POST',
        read: 'POST',
        update: 'POST',
        destroy: 'POST'
    },

    // constructor: function (config) {
    //     this.initConfig(config);
    // },

    buildJson: function (operation) {
        var jsonParams = '';
        if (operation.action == 'read') {
            if (!!operation.id) {
                jsonParams = Ext.JSON.encode({ id: operation.id });
            } else if (!!operation.params) {
                jsonParams = Ext.JSON.encode(operation.params);
            } else if (!!operation.node) {
                jsonParams = Ext.JSON.encode(operation.node.data);
            }
        }
        return jsonParams;
    },

    encodeSorters: function (sorters) {
        var min = [],
            length = sorters.length,
            i = 0;

        for (; i < length; i++) {
            min[i] = {
                property: sorters[i].property,
                direction: sorters[i].direction
            };
        }
        return min;
    },
    read: function (operation, callback, scope) {
        if (arguments[0].action == 'readpage') {
            var reader = this.getReader(),
                result = { records: arguments[0].datasnapshoot },
                sorters, filters, sorterFn, records;

            scope = scope || this;
            filters = operation.filters;
            if (filters.length > 0) {
                records = [];
                Ext.each(result.records, function (record) {
                    var isMatch = true,
                    length = filters.length,
                    i;

                    for (i = 0; i < length; i++) {
                        var filter = filters[i],
                        fn = filter.filterFn,
                        scope = filter.scope;

                        isMatch = isMatch && fn.call(scope, record);
                    }
                    if (isMatch) {
                        records.push(record);
                    }
                }, this);
                result.records = records;
                result.totalRecords = result.total = records.length;
            }

            // sorting
            sorters = operation.sorters;
            if (sorters.length > 0) {
                //construct an amalgamated sorter function which combines all of the Sorters passed
                sorterFn = function (r1, r2) {
                    var result = sorters[0].sort(r1, r2),
                    length = sorters.length,
                    i;

                    //if we have more than one sorter, OR any additional sorter functions together
                    for (i = 1; i < length; i++) {
                        result = result || sorters[i].sort.call(this, r1, r2);
                    }

                    return result;
                };

                result.records.sort(sorterFn);
            }

            result.total = result.records.length;
            // paging (use undefined cause start can also be 0 (thus false))
            if (operation.start !== undefined && operation.limit !== undefined) {
                result.records = result.records.slice(operation.start, operation.start + operation.limit);
                result.count = result.records.length;
            }

            Ext.apply(operation, {
                resultSet: result
            });

            operation.setCompleted();
            operation.setSuccessful();

            Ext.Function.defer(function () {
                Ext.callback(callback, scope, [operation]);
            }, 10);
        } else {
            return this.doRequest.apply(this, arguments);
        }
    },
    processResponse: function (success, operation, request, response, callback, scope) {
        var me = this,
            action = operation.getAction(),
            reader, resultSet;
            
        response.request.options.operation=response.request.options._operation;

        if (success === true) {
            reader = me.getReader();

            resultSet = reader.process(me.getResponseResult(response));

            // This could happen if the model was configured using metaData
            if (!operation.getModel()) {
                operation.setModel(this.getModel());
            }

            if (operation.process(action, resultSet, request, response) === false) {
                me.fireEvent('exception', me, response, operation);
            }
        } else {
            me.setException(operation, response);
            /**
             * @event exception
             * Fires when the server returns an exception
             * @param {Ext.data.proxy.Proxy} this
             * @param {Object} response The response from the AJAX request
             * @param {Ext.data.Operation} operation The operation that triggered request
             */
            me.fireEvent('exception', this, response, operation);
        }

        //this callback is the one that was passed to the 'read' or 'write' function above
        if (typeof callback == 'function') {
            callback.call(scope || me, operation);
        }

        me.afterRequest(request, success);
    },
    doRequest: function (operation, callback, scope) {
        //debugger;
        var me = this, writer = me.getWriter(), request = me.buildRequest(operation, callback, scope);

        //set request.url
        request.url = request._url;

        request.jsonData = me.buildJson(operation);
        delete request.params;

        Ext.apply(request, {
            headers: me.headers,
            timeout: me.timeout,
            scope: me,
            callback: me.createRequestCallback(request, operation, callback, scope),
            method: me.getMethod(request) || 'POST',
            disableCaching: false
        });

        if (request.params) request.params = Ext.JSON.encode(request.params);

        Ext.Ajax.request(request);

        return request;
    }
});