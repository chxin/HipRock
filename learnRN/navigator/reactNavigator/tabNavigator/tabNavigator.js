import React, { Component } from 'react';
import {
	AppRegister, BackHandler, Platform
} from 'react-native';
import { StackNavigator, TabNavigator } from 'react-navigation';
import LoginLeaf from '../stackNavigator/LoginLeaf';
import WaitingLeaf from '../stackNavigator/WaitingLeaf';
import Mine from './Mine';

const MainScreenNavigator = StackNavigator({
	Login: { screen: LoginLeaf },
	Wait: { screen: WaitingLeaf },
});

const SimpleApp = TabNavigator({
	Home: { screen: MainScreenNavigator },
	Mine: { screen: Mine },
});

export default class tabNavigation extends Component {
	render() {
		return (
			<SimpleApp/>
		);
	}
}
