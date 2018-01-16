import React, { Component } from 'react';
import {
	StyleSheet, Text, View, Image
} from 'react-native';
import PropTypes from 'prop-types';

export default class WaitingLeaf extends Component {
	static navigationOptions = {
		drawerLabel: 'Waiting',
		drawerIcon: ({ tintColor }) => (
			<Image 
				source={require('./notif-icon.png')}
				style={[styles.icon, {tintColor:tintColor}]}
			/>
		),
	};
	constructor(props) {
		super(props);
	}

	render() {
		return (
			<View style={styles.container}>
				<Text style={styles.textPromptStyle} >
					登录使用手机号:{this.props.phoneNumber}
				</Text>
				<Text style={styles.textPromptSytle}>
					登录使用密码:{this.props.userPW}
				</Text>
				<Text style={styles.bigTextPrompt}
					onPress={()=>this.onGobackPressed()}>
					返回
				</Text>
			</View>
		);
	}
	onGobackPressed() {
		this.props.navigation.navigate('DrawerOpen');
	}
}

WaitingLeaf.propTypes = {
	phoneNumber: PropTypes.string,
	userPW: PropTypes.string
}

let styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		backgroundColor: '#F5FcFF',
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
