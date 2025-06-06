import * as LiveActivity from "expo-live-activity";
import {
  Button,
  StyleSheet,
  TextInput,
  View,
  Text,
  Keyboard,
  Pressable,
} from "react-native";
import { useState } from "react";

export default function App() {
  const [activityId, setActivityID] = useState<String | null>();
  const [title, onChangeTitle] = useState("");
  const [subtitle, onChangeSubtitle] = useState("");
  const [minutes, setMinutes] = useState(5);

  const startActivity = () => {
    Keyboard.dismiss();
    const state = {
      title: title,
      subtitle: subtitle,
      date: Date.now() + minutes * 60 * 1000,
    };
    const id = LiveActivity.startActivity(state);
    console.log(id);
    setActivityID(id);
  };

  const stopActivity = () => {
    const state = {
      title: title,
      subtitle: subtitle,
      date: Date.now(),
    };
    activityId && LiveActivity.stopActivity(activityId, state);
    setActivityID(null);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Set Live Activity title:</Text>
      <TextInput
        style={styles.input}
        onChangeText={onChangeTitle}
        placeholder="Live activity title"
        value={title}
      />
      <Text style={styles.label}>Set Live Activity subtitle:</Text>
      <TextInput
        style={styles.input}
        onChangeText={onChangeSubtitle}
        placeholder="Live activity title"
        value={subtitle}
      />
      <Text style={styles.label}>Set Live Activity timer:</Text>
      <View style={styles.timerControlsContainer}>
        <Pressable style={styles.minus} onPress={() => { setMinutes(minutes - 1)}} disabled={minutes <= 0 }>
          <Text style={styles.timerControlsText}>-</Text>
        </Pressable>
        <Text style={styles.timerControlsText}>{minutes}</Text>
        <Pressable style={styles.plus} onPress={() => { setMinutes(minutes + 1)}} disabled={minutes >= 60}>
          <Text style={styles.timerControlsText}>+</Text>
        </Pressable>
      </View>
      <View style={styles.buttonsContainer}>
        <Button
          title="Start Activity"
          onPress={startActivity}
          disabled={title === "" || !!activityId }
        />
        <Button
          title="Stop Activity"
          onPress={stopActivity}
          disabled={!activityId}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  timerControlsContainer: {
    flexDirection: 'row',
    padding: 10,
    margin: 10,
    width: '90%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  minus: {
    marginRight: 50,
    width: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  plus: {
    marginLeft: 50,
    width: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  timerControlsText: {
    fontSize: 17
  },
  buttonsContainer: {
    padding: 20,
  },
  label: {
    width: "90%",
    fontSize: 17,
  },
  input: {
    height: 45,
    width: "90%",
    margin: 12,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 10,
    padding: 10,
  },
});
