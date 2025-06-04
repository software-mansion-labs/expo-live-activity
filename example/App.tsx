import * as LiveActivity from 'expo-live-activity';
import { Button, Text, View } from 'react-native';

export default function App() {
  const state = {
    title: "Title longer",
    subtitle: "This is a subtitle",
    date: Date.now() + 5*60*1000
  }
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Theme: {LiveActivity.hello()}</Text>
      <Button title="Start Activity" onPress={() => LiveActivity.startActivity(state)} />
    </View>
  );
}
