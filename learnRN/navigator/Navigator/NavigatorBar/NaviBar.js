import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
	StyleSheet, Text, View, TouchableHighlight, Dimensions
} from 'react-native';

let totalWidth = Dimensions.get('window').width;
let naviButtonWidth = totalWidth / 4;
let naviButtonHeight = naviButtonWidth * 0.75;

export default class NaviBar extends Component {
	constructor(props) {
		super(props);
		this._naviTab0Pressed = this._naviTab0Pressed.bind(this);
		this._naviTab1Pressed = this._naviTab1Pressed.bind(this);
		this._naviTab2Pressed = this._naviTab2Pressed.bind(this);
		this._naviTab3Pressed = this._naviTab3Pressed.bind(this);
	}

	componentWillMount() {
		this.buttonColors = this.props.naviBarStatus.map(
			function(aNumber) {
				if (aNumber == 0) return 'white';
				return 'grey';
			}
		);
	}

	_naviTab0Pressed() {
		this.props.onNaviBarPress(0);
	}
	_naviTab1Pressed() {
		this.props.onNaviBarPress(1);
	}
	_naviTab2Pressed() {
		this.props.onNaviBarPress(2);
	}
	_naviTab3Pressed() {
		this.props.onNaviBarPress(3);
	}

	render() {
		return (
			<View style={styles.naviRow}>
				<TouchableHighlight onPress={this._naviTab0Pressed}>
					<View style={[styles.button,{backgroundColor:this.buttonColors[0]}]}>
						<Text style={styles.textStyle}>
							栏目一
						</Text>
					</View>
				</TouchableHighlight>
				<TouchableHighlight onPress={this._naviTab1Pressed}>
					<View style={[styles.button,{backgroundColor:this.buttonColors[1]}]}>
						<Text style={styles.textStyle}>
							栏目二
						</Text>
					</View>
				</TouchableHighlight>
				<TouchableHighlight onPress={this._naviTab2Pressed}>
					<View style={[styles.button,{backgroundColor:this.buttonColors[2]}]}>
						<Text style={styles.textStyle}>
							栏目三
						</Text>
					</View>
				</TouchableHighlight>
				<TouchableHighlight onPress={this._naviTab3Pressed}>
					<View style={[styles.button,{backgroundColor:this.buttonColors[3]}]}>
						<Text style={styles.textStyle}>
							栏目四
						</Text>
					</View>
				</TouchableHighlight>
			</View>
		);
	}
}

NaviBar.propTypes = {
	naviBarStatus: PropTypes.arrayOf(PropTypes.number).isRequired,
	onNaviBarPress: PropTypes.func.isRequired,
};


var styles = StyleSheet.create({
	naviRow: {
		flexDirection: 'row',
	},
	button: {
		width: naviButtonWidth,
		height: naviButtonHeight,
		justifyContent: 'center',
	},
	textStyle: {
		fontSize: 20,
		textAlign: 'center',
	}
});
