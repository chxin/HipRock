import React, { Component } from 'react';
import {
	StyleSheet, Text, View, Image
} from 'react-native';
import { NavigationAction } from 'react-navigation';

export default class Mine extends Component {
	static navigationOptions = {
		drawerLabel: 'Mine',
		drawerIcon: ({ tintColor }) => (
			<Image 
				source={require('./Mine-icon.png')}
				style={[styles.icon,{tintColor: tintColor}]}
			/>
		),
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
	icon: {
		width: 24,
		height: 24,
	},
	bigTextPrompt: {
		width: 300,
		backgroundColor: 'grey',
		color: 'white',
		textAlign: 'center',
		fontSize: 60
	}
});