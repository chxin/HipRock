import React, { Component } from 'react';
import {
	StyleSheet, Text, View
} from 'react-native';
import { NavigationAction } from 'react-navigation';

export default class Mine extends Component {
	static navigationOptions = {
		title: '登录中',
	};
	render() {
		console.log( 'list state of route.' );
		console.log( this.props.navigation.state );
			return (
				<View style={styles.container}>
					<Text style={styles.textPromptStyle}>
						我的
					</Text>
				</View>
			);
	}
	componentWillUnmount() {
		console.log( 'Mine will close.' );
	}
}

let styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		backgroundColor: '#F5FCFF',
	},
	textPromptStyle: {
		fontSize: 20
	},
	bigTextPrompt: {
		width: 300,
		backgroundColor: 'grey',
		color: 'white',
		textAlign: 'center',
		fontSize: 60
	}
})