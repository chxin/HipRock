Ext.define('Blues.view.Main',{
	extend:'Ext.Container',
	xtype:'mainview',

	requires:['Blues.view.layout.NavigationView','Blues.view.layout.ContentView'],

	config:{
	    fullscreen: true,

	    layout: {
	    	type:'hbox',
	    },

		items:[{
            xtype: 'navigationview',
            docked: 'left',
            width: 200,
	    },{
	    	xtype:'contentview',
            flex: 1
	    }],
	},

	initialize:function () {
		Ext.Viewport.on('orientationchange', this.handleOrientationChange, this, {buffer: 50 });

		this.callParent(arguments);
	},

	handleOrientationChange:function (viewport, newOrientation, width, height, options) {
		// body...
		// console.log('orientation changed');
		// var animation = Ext.create('Ext.Anim',{
		//   autoClear: false,
		//   to: {'width':width+'px; height:'+height+'px'},
		//   duration: 5000
		// });

		// animation.run(this.getView().element);
		console.log('orientation changed');
		
		this.setSize(width,height);
	}

});