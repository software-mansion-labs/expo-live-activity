import * as LiveActivity from 'expo-live-activity';
import { Text, View } from 'react-native';

export default function App() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Theme: {LiveActivity.startActivity()}</Text>
    </View>
  );
}
