import React from 'react';
import { StyleSheet, Text } from 'react-native';
var NavigationBarRouteMapper = {
	leftButton(route, navigator, index, navState) {
		let pString;
		if (route.textForLeftButton !== undefined) pString = route.textForLeftButton;
		else pString = '上一个';
		if (index > 0) {
			return ( <Text style = { styles.buttonStyle }
					onPress = {
						() => {try{
							route.cbForLeftButton(route.UIIndex);
							navigator.jumpBack();
						}catch (error) {}
						}
					}>
						{pString}
					</Text>
				);
		}
		else {
			return (
				<Text sytle={[styles.buttonStyle,{color:'red'}]}>
					{pString}
				</Text>
			);
		}
	},
	Title(route, navigator, index, navState) {
		return (
			<Text style={styles.titleStyle}>
				第{route.UIIndex}个界面
			</Text>
		)
	},
	RightButton(route,navigator,index,navState) {
		if (navState.sceneConfigStack.length === index + 1) {
			console.log(' no onpress for right button');
			return (
				<Text style={[styles.buttonStyle,{color:'red'}]}>
					下一个
				</Text>
			)
		}
		return ( <Text style = {styles.buttonStyle}
				onpress = {() => {
					if (navState.sceneConfigStack.length === index + 1) {
						console.log('Can not jump forward');
					}
					else navigator.jumpForward()
				}
			}>
			下一个
			</Text>
			)
	}
};
var styles = StyleSheet.create({
	buttonStyle:{
		fontSize: 20,
		margin: 10,
		backgroundColor: 'grey',
		width: 70
	},
	titleStyle: {
		fontSize: 20,
		margin: 10,
		left: 10,
		textAlign: 'center'
	}
});
export default NavigationBarRouteMapper;


