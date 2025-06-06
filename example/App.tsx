import * as LiveActivity from "expo-live-activity";
import { Button, StyleSheet, TextInput, View, Text } from "react-native";
import { useState } from "react";

export default function App() {
  const [activityId, setActivityID] = useState<String | null>();
  const [title, onChangeTitle] = useState("");
  const [subtitle, onChangeSubtitle] = useState("");
  const [minutes, onChangeMinutes] = useState('');

  const startActivity = () => {
    let timerMinutes = +minutes
    if (timerMinutes) {
      const state = {
        title: title,
        subtitle: subtitle,
        date: Date.now() + timerMinutes * 60 * 1000,
      };
      const id = LiveActivity.startActivity(state);
      console.log(id);
      setActivityID(id);
    } else {
      console.log("Enter valid time")
    }
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
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
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
      <TextInput
          style={styles.input}
          onChangeText={onChangeMinutes}
          value={minutes}
          placeholder="Minutes"
          keyboardType="numeric"
        />
      <View style={styles.buttonsContainer}>
        <Button
          title="Start Activity"
          onPress={startActivity}
          disabled={title === ""}
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
  buttonsContainer: {
    padding: 20
  },
  label: {
    width: '90%',
    fontSize: 17,
  },
  input: {
    height: 45,
    width: '90%',
    margin: 12,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 10,
    padding: 10,
  },
});
