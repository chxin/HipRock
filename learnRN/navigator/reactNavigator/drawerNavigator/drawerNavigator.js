import React, { Component } from 'react';
import {
	AppRegister, BackHandler, Platform, Button
} from 'react-native';
import { DrawerNavigator } from 'react-navigation';
import LoginLeaf from './LoginLeaf';
import WaitingLeaf from './WaitingLeaf';
import Mine from './Mine';

const SimpleApp = DrawerNavigator({
	Login: { screen: LoginLeaf },
	Wait: { screen: WaitingLeaf },
	Home: { screen: Mine },
});

export default class drawerNavigation extends Component {
	render() {
		return (
			<SimpleApp/>
		);
	}
}
