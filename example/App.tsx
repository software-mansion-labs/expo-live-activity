import * as LiveActivity from 'expo-live-activity';
import { Button, Text, View } from 'react-native';
import { useState } from 'react';

export default function App() {
  const [activityId, setActivityID] = useState<String | null>()

  const state = {
    title: "Title longer",
    subtitle: "This is a subtitle",
    date: Date.now() + 5*60*1000
  }

  const startActivity = () => {
    const id = LiveActivity.startActivity(state)
    console.log(id)
    setActivityID(id)
  }

  const stopActivity = () => {
    activityId && LiveActivity.stopActivity(activityId, state)
    setActivityID(null)
  }

  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Theme: {LiveActivity.hello()}</Text>
      <Button title="Start Activity" onPress={startActivity} />
      <Button title="Stop Activity" onPress={stopActivity} disabled={!activityId} />
    </View>
  );
}
