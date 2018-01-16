import React, { Component } from 'react';
import { Navigator } from 'react-native-deprecated-custom-components';
import {
  AppRegistry, PixelRatio
} from 'react-native';
import ImageDisplayer from './ImageDisplayer';
import NavigationBarRouteMapper from "./NavigationBarRouteMapper";

let pixelRatio = PixelRatio.get();

export default class NavigatorSwitch extends Component {
  constructor(props) {
    super(props);
    this.touchtime=0;
    this.switchSceneStyle=Navigator.SceneConfigs.PushFromRight;
    this.initialRoute = {
      UIIndex:0,
      cbForLeftButton:this.callbackforLeftButton
    };
    this.state = {textPromt:'', UIIndex:0 };
    this.renderScene = this.renderScene.bind(this);
    this.changeStateVarBeforeRoute = this.changeStateVarBeforeRoute.bind(this);
    this.configureScene = this.configureScene.bind(this);
  }
  renderScene(router, Navigator) {
    return <ImageDisplayer navigator={navigator}
        textForLeftButton={'新文字'}
        cbForLeftButton={this.callbackforLeftButton}
        UIIndex={this.state.UIIndex}
        textPromt={this.state.textPromt}
        callback={this.changeStateVarBeforeRoute}/>
  }
  callbackforLeftButton(aNumber) {
    console.log('call back function received number:'+aNumber);
  }
  configureScene(route) {
    return this.switchSceneStyle;
  }
  render() {
    return (  <Navigator initialRoute={this.initialRoute}
                configureScene = {this.state.switchSceneStyle}
                navigatorBar = {<Navigator.NavigationBar
                  routeMapper={ NavigationBarRouteMapper } />}
                renderScene = {this.renderScene} >
              </Navigator>
      );
    }
  changeStateVarBeforeRoute() {
    this.touchtime++;
    let textPromt;
    switch (this.touchtime % 12) {
      case 0:
        textPromt = 'PushFromRight';
        this.switchSceneStyle = Navigator.SceneConfigs.PushFromright;
        break;
      case 1:
        textPromt = 'FloatFromRight';
        this.switchSceneStyle = Navigator.SceneConfigs.FloatFromright;
        break;
      case 2:
        textPromt = 'FloatFromLeft';
        this.switchSceneStyle = Navigator.SceneConfigs.FloatFromLeft;
        break;
      case 3:
        textPromt = 'FloatFromBottom';
        this.switchSceneStyle = Navigator.SceneConfigs.FloatFromBottom;
        break;
      case 4:
        textPromt = 'FloatFromBottomAndroid';
        this.switchSceneStyle = Navigator.SceneConfigs.FloatFromButtomAndroid;
        break;
      case 5:
        textPromt = 'FadeAndroid';
        this.switchSceneStyle = Navigator.SceneConfigs.FadeAndroid;
        break;
      case 6:
        textPromt = 'SwipeFromLeft';
        this.switchSceneStyle = Navigator.SceneConfigs.SwipeFromLeft;
        break;
      case 7:
        textPromt = 'HorizontalSwipeJump';
        this.switchSceneStyle = Navigator.SceneConfigs.HorizontalSwipeJump;
        break;
      case 8:
        textPromt = 'HorizontalSwipeJumpFromRight';
        this.switchSceneStyle = Navigator.SceneConfigs.HorizontalSwipeJumpFromright;
        break;
      case 9:
        textPromt = 'HorizontalSwipeJumpFromLeft';
        this.switchSceneStyle = Navigator.SceneConfigs.HorizontalSwipeJumpFromLeft;
        break;
      case 10:
        textPromt = 'VerticalUpSwipeJump';
        this.switchSceneStyle = Navigator.SceneConfigs.VerticalUpSwipeJump;
        break;
      case 11:
        textPromt = 'VerticalDownSwipeJump';
        this.switchSceneStyle = Navigator.SceneConfigs.VerticalDownSwipeJump;
    }
    this.setState({ textPromt, UIIndex:this.state.UIIndex+1 });
  }
}