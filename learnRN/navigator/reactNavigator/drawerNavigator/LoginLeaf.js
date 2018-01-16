import React, { Component } from 'react';
import {
	StyleSheet, Text, View, Dimensions, TextInput, Alert, Image
} from 'react-native';
let widthOfMargin = Dimensions.get('window').width * 0.05;

export default class LoginLeaf extends Component {
	static navigationOptions = {
		drawerLabel: 'Login',
		drawerIcon: ({ tintColor }) => (
			<Image 
				source={require('./chats-icon.png')}
				style={[styles.icon,{tintColor:tintColor}]}
			/>
		),
	};
	constructor(props) {
		super(props);
		this.state = {
			inputNum:'',
			inputPW: ''
		};
		this.updateNum = this.updateNum.bind(this);
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

	userPressConfirm() {
		this.props.navigation.navigate('DrawerOpen');
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
	icon: {
		width: 24,
		height: 24,
	},
	bigTextPrompt: {
		margin: widthOfMargin,
		backgroundColor: 'grey',
		color: 'white',
		textAlign: 'center',
		fontSize: 30
	}
});
