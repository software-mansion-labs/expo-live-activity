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
import RNDateTimePicker from "@react-native-community/datetimepicker";

export default function App() {
  const [activityId, setActivityID] = useState<String | null>();
  const [title, onChangeTitle] = useState("");
  const [subtitle, onChangeSubtitle] = useState("");
  const [date, setDate] = useState(new Date());

  const startActivity = () => {
    Keyboard.dismiss();
    const state = {
      title: title,
      subtitle: subtitle,
      date: date.getTime(),
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

  const updateActivity = () => {
    const state = {
      title: title,
      subtitle: subtitle,
      date: date.getTime(),
    };
    activityId && LiveActivity.updateActivity(activityId, state);
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
        <RNDateTimePicker value={date} mode="time" onChange={(event, date) => { date && setDate(date) }} />
      </View>

      <View style={styles.buttonsContainer}>
        <Button
          title="Start Activity"
          onPress={startActivity}
          disabled={title === "" || !!activityId}
        />
        <Button
          title="Stop Activity"
          onPress={stopActivity}
          disabled={!activityId}
        />
        <Button
          title="Update Activity"
          onPress={updateActivity}
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
    flexDirection: "row",
    marginTop: 15,
    width: "90%",
    alignItems: "center",
    justifyContent: "center",
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
