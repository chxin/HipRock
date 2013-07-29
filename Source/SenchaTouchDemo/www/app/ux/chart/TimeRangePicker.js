Ext.define('Blues.ux.chart.TimeRangePicker',{
	extend: 'Ext.Panel',
	alias: 'widget.timerangepicker',

	requires: ['Ext.form.FieldSet','Ext.picker.Date','Ext.field.Text','Ext.Button'],

	config:{
		id: 'timerangepicker',
		layout: 'vbox',
		height: 366,
		width: 300,
		style: 'background: #fff; border: 1px solid #eee;',
		items:[{
			xtype: 'fieldset',
			docked: 'top',
			items: [{
				xtype: 'textfield',
				name: 'from',
				label: 'From',
			},{
				xtype: 'textfield',
				name: 'to',
				label: 'To',
			}]
		},{
			xtype: 'datepicker',
			id: 'timepicker',
			margin: '0 8',
			flex: 1,
			doneButton: false,
			cancelButton: false,
			modal: false,
			slotOrder: ['year','month','day'],
		},{
			xtype: 'container',
			layout: 'hbox',
			docked: 'bottom',
			items: [{
				xtype: 'button',
				id: 'datepicker-confirm',
				ui: 'confirm',
				text: 'Confirm',
				margin: 8,
				docked: 'right',
			},{
				xtype: 'button',
				id: 'datepicker-cancel',
				ui: 'decline',
				text: 'Cancel',
				margin: 8,
				docked: 'left',
			}]
		}],

	},

	initialize: function () {
		this.callParent(arguments);

		var me = this;

		me.down('#datepicker-cancel').on({
			tap: function () {
				me.destroy();
			}
		});

	},
});