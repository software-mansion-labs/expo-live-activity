import * as LiveActivity from 'expo-live-activity';
import { Button, Text, View } from 'react-native';

export default function App() {
  const state = {
    title: "Hello",
    subtitle: "This is working"
  }
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Theme: {LiveActivity.hello()}</Text>
      <Button title="Start Activity" onPress={() => LiveActivity.startActivity(state)} />
    </View>
  );
}
