import * as React from 'react';
import { View, Text, Button } from 'react-native';
import { createStaticNavigation, useNavigation } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import CreateLiveActivityScreen from './screens/CreateLiveActivityScreen';
import { LiveActivityProvider } from 'expo-live-activity';

function HomeScreen() {
  const navigation = useNavigation();

  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Home Screen</Text>
      <Button title="Create Live Activity" onPress={() => { navigation.navigate('CreateLiveActivity') }} />
    </View>
  );
}

const RootStack = createNativeStackNavigator({
  initialRouteName: 'Home',
  screens: {
    Home: HomeScreen,
    CreateLiveActivity: CreateLiveActivityScreen
  },
});

const Navigation = createStaticNavigation(RootStack);

export default function App() {
  return (
    <LiveActivityProvider>
      <Navigation />
    </LiveActivityProvider>
  );
}