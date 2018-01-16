import React, { Component } from 'react';
import {
	StyleSheet, Text, View, Dimensions, TextInput, Alert
} from 'react-native';
let widthOfMargin = Dimensions.get('window').width * 0.05;

export default class LoginLeaf extends Component {
	static navigationOptions = {
		title: '登录',
	};
	constructor(props) {
		super(props);
		this.state = {
			inputNum:'',
			inputPW: ''
		};
		this.updateNum = this.updateNum.bind(this);
		this.jumpToWaiting = this.jumpToWaiting.bind(this);
	}
	updateNum(newText) {
		this.setState((state) => {
			return {
				inputedNum: newText,
			};
		});
	}
	updatePW(newText) {
		this.setState(() => {
			return {
				inputedPW: newText,
			};
		});
	}

	render() {
		return (
			<View style={styles.container}>
				<TextInput style={styles.textInputStyle}
					placeholder={'请输入手机号'}
					onChangeText={this.updateNum}/>
				<Text style={styles.textPromptStyle}>
					你输入的手机号:{this.state.inputedNum}
				</Text>
				<TextInput style={styles.textInputStyle}
					placeholder={'请输入密码'}
					secureTextEntry={true}
					onChangeText={this.updatePW.bind(this)}/>
				<Text style={styles.bigTextPrompt}
					onPress={()=>this.userPressConfirm()}>
					确定
				</Text>
				<Text style={styles.bigTextPrompt}
					onPress={()=>this.userPressAddressBook()}>
					通讯录
				</Text>
			</View>
		);
	}

	jumpToWaiting() {
		this.props.navigation.navigate( 'Wait',
			{
				phoneNumber:this.state.inputedNum,
				userPW:this.state.inputedPW
			}
		);
	}

	userPressConfirm() {
		Alert.alert(
			'提示',
			'确定使用'+this.state.inputedNum+'号码登录吗？',
			[
				{text: '取消', onPress:(()=>{}), style: 'cancel' },
				{text: '确定', onPress: this.jumpToWaiting }
			]
		);
	}

	userPressAddressBook() {
		
	}
}

let styles = StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: 'white'
	},
	textInputStyle: {
		margin: widthOfMargin,
		backgroundColor: 'grey',
		fontSize: 20
	},
	textPromptStyle: {
		margin: widthOfMargin,
		fontSize: 20
	},
	bigTextPrompt: {
		margin: widthOfMargin,
		backgroundColor: 'grey',
		color: 'white',
		textAlign: 'center',
		fontSize: 30
	}
});
