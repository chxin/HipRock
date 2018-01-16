import React, { Component } from 'react';
import {
  StyleSheet, Text, View
} from 'react-native';

export default class callbackFunc extends Component {
  constructor(props) {
    super(props);
    this.onTouchMove = this.onTouchMove.bind(this);
    this.onTouchStart = this.onTouchStart.bind(this);
    this.onTouchEnd = this.onTouchEnd.bind(this);
  }

  onTouchMove(event) {
    console.warn("touch move:" + event.timeStamp + ',X:' + event.nativeEvent.locationX + ',Y:' + event.nativeEvent.locationY);
  }
  onTouchStart(event) {
    console.warn("touch start:" + event.timStamp + ',X:' + event.nativeEvent.locationX + ',Y:' + event.nativeEvent.locationY);
  }
  onTouchEnd(event) {
    console.warn("touch end:" + event.timeStamp + ',X:' + event.nativeEvent.locationX + ':Y:' + event.nativeEvent.locationY);
  }

  render() {
    return (
      <View style={styles.container}
        onTouchStart={this.onTouchStart}
        onTouchMove={this.onTouchMove}
        onTouchEnd={this.onTouchEnd}>
      </View>
    );
  }
}

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF'
  }
});