import {
  createStaticNavigation,
  StaticParamList,
} from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";

import CreateLiveActivityScreen from "./screens/CreateLiveActivityScreen";
import HomeScreen from "./screens/HomeScreen";

const RootStack = createNativeStackNavigator({
  initialRouteName: "Home",
  screens: {
    Home: HomeScreen,
    CreateLiveActivity: CreateLiveActivityScreen,
  },
});

const Navigation = createStaticNavigation(RootStack);

type RootStackParamList = StaticParamList<typeof RootStack>;

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

export default Navigation;
