import React, { Component } from 'react';
import {
	StyleSheet, View, Text
} from 'react-native';
import NaviBar from './NaviBar';

export default class Page1 extends Component {
	constructor(props) {
		super(props);
		this.state = {
			inputedNum:'',
			imputedPW:'',
		};
		this.onNaviBarPress = this.onNaviBarPress.bind(this);
		this.naviStatus = [1, 0, 0, 0];
	}

	onNaviBarPress(aNumber) {
		switch(aNumber) {
			case 0:
				return;
			case 1:
				this.props.navigator.replace({ name: 'Page2' });
				return;
			case 2:
				this.props.navigator.replace({ name: 'Page3' });
				return;
			case 3:
				this.props.navigator.replace({ name: 'Page4' });
				return;
		}
	}

	render() {
		return(
			<View style={styles.container}>
				<NaviBar naviBarStatus={this.naviStatus}
					onNaviBarPress={this.onNaviBarPress}/>
				<View style={styles.whatLeft} >
					<Text>
						栏目一内容
					</Text>
				</View>
			</View>	
		);
	}
}

var styles = StyleSheet.create({
	container: {
		flex: 1,
	},
	whatLeft: {
		flex: 1,
		borderTopWidth: 1,
		borderColor: 'black',
	}
});
