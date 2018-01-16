import React, { Component } from 'react';
import {
	StyleSheet, Text, View
} from 'react-native';
import PropTypes from 'prop-types';

export default class WaitingLeaf extends Component {
	static navigationOptions = {
		title: '登录中',
	};
	constructor(props) {
		super(props);
		this.onGobackPressed = this.onGobackPressed.bind(this);
	}

	render() {
		const { params } = this.props.navigation.state;
		return (
			<View style={styles.container}>
				<Text style={styles.textPromptStyle} >
					登录使用手机号:{params.phoneNumber}
				</Text>
				<Text style={styles.textPromptSytle}>
					登录使用密码:{params.userPW}
				</Text>
				<Text style={styles.bigTextPrompt}
					onPress={this.onGobackPressed}>
					返回
				</Text>
			</View>
		);
	}
	onGobackPressed() {
		this.props.navigation.goBack();
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
	bigTextPrompt: {
		width: 300,
		backgroundColor: 'grey',
		color: 'white',
		textAlign: 'center',
		fontSize: 60
	}
});
