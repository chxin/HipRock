import React, { Component } from 'react';
import {
	AppRegister
} from 'react-native';
import { StackNavigator } from 'react-navigation';
import LoginLeaf from './LoginLeaf';
import WaitingLeaf from './WaitingLeaf';

const SimpleApp = StackNavigator({
	Home: { screen: LoginLeaf },
	Wait: { screen: WaitingLeaf },
});

export default class stackNavigation extends Component {
	render() {
		return (
			<SimpleApp/>
		);
	}
}
