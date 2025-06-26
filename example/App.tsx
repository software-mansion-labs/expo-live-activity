import * as LiveActivity from "expo-live-activity";
import {
  Button,
  StyleSheet,
  TextInput,
  View,
  Text,
  Keyboard,
  Platform,
} from "react-native";
import { useState } from "react";
import RNDateTimePicker from "@react-native-community/datetimepicker";

export default function App() {
  const [activityId, setActivityID] = useState<string | null>();
  const [title, onChangeTitle] = useState("");
  const [subtitle, onChangeSubtitle] = useState("");
  const [imageName, onChangeImageName] = useState("live_activity_image");
  const [date, setDate] = useState(new Date());

  const startActivity = () => {
    Keyboard.dismiss();
    const state = {
      title: title,
      subtitle: subtitle,
      date: date.getTime(),
      imageName: imageName,
    };
    try {
      const id = LiveActivity.startActivity(state);
      console.log(id);
      setActivityID(id);
    } catch (e) {
      console.error("Starting activity failed! " + e);
    }
  };

  const stopActivity = () => {
    const state = {
      title: title,
      subtitle: subtitle,
      date: Date.now(),
      imageName: imageName,
    };
    try {
      activityId && LiveActivity.stopActivity(activityId, state);
      setActivityID(null);
    } catch (e) {
      console.error("Stopping activity failed! " + e);
    }
  };

  const updateActivity = () => {
    const state = {
      title: title,
      subtitle: subtitle,
      date: date.getTime(),
      imageName: imageName,
    };
    try {
      activityId && LiveActivity.updateActivity(activityId, state);
    } catch (e) {
      console.error("Updating activity failed! " + e);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.inputs}>
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
        <Text style={styles.label}>Set Live Activity image:</Text>
        <TextInput
          style={styles.input}
          onChangeText={onChangeImageName}
          autoCapitalize="none"
          placeholder="Live activity image"
          value={imageName}
        />
        {Platform.OS === "ios" && (
          <View>
            <Text style={styles.label}>Set Live Activity timer:</Text>
            <View style={styles.timerControlsContainer}>
              <RNDateTimePicker
                value={date}
                mode="time"
                onChange={(event, date) => {
                  date && setDate(date);
                }}
                minimumDate={new Date(Date.now() + 60 * 1000)}
              />
            </View>
          </View>
        )}
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
  inputs: {
    alignItems: "flex-start",
    width: "90%",
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
    width: "100%",
    marginVertical: 12,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 10,
    padding: 10,
  },
});
