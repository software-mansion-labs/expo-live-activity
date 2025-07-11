import { useLiveActivity, DynamicIslandTimerType } from 'expo-live-activity';
import {
  Button,
  StyleSheet,
  TextInput,
  View,
  Text,
  Keyboard,
  Switch,
  Platform,
} from "react-native";
import { useState, useEffect } from "react";
import RNDateTimePicker from "@react-native-community/datetimepicker";
import { useNavigation } from '@react-navigation/native';

export default function CreateLiveActivityScreen
() {
  const [activityId, setActivityID] = useState<string | null>();
  const [title, onChangeTitle] = useState("Title");
  const [subtitle, onChangeSubtitle] = useState("This is a subtitle");
  const [imageName, onChangeImageName] = useState("logo");
  const [date, setDate] = useState(new Date());
  const [timerType, setTimerType] = useState<DynamicIslandTimerType>("circular");
  const [passSubtitle, setPassSubtitle] = useState(true);
  const [passImage, setPassImage] = useState(true);
  const [passDate, setPassDate] = useState(true);

  const liveActivity = useLiveActivity();
  const navigation = useNavigation();

  let backgroundColor = "001A72";
  let titleColor = "EBEBF0";
  let subtitleColor = "#FFFFFF75";
  let progressViewTint = "38ACDD";
  let progessViewLabelColor = "#FFFFFF";

  const startActivity = () => {
    Keyboard.dismiss();
    const state = {
      title: title,
      subtitle: passSubtitle ? subtitle : undefined,
      date: passDate ? date.getTime() : undefined,
      imageName: passImage ? imageName : undefined,
      dynamicIslandImageName: "logo-island",
    };

    const styles = {
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      subtitleColor: subtitleColor,
      progressViewTint: progressViewTint,
      progressViewLabelColor: progessViewLabelColor,
      timerType: timerType,
    };
    try {
      const id = liveActivity.startActivity(state, styles);
      console.log(id);
      setActivityID(id);
    } catch (e) {
      console.error("Starting activity failed! " + e);
    }
    navigation.goBack()
  };

  const stopActivity = () => {
    const state = {
      title: title,
      subtitle: subtitle,
      date: Date.now(),
      imageName: imageName,
      dynamicIslandImageName: "logo-island",
    };
    try {
      activityId && liveActivity.stopActivity(activityId, state);
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
      dynamicIslandImageName: "logo-island",
    };
    try {
      activityId && liveActivity.updateActivity(activityId, state);
    } catch (e) {
      console.error("Updating activity failed! " + e);
    }
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
      <View style={styles.labelWithSwitch}>
        <Text style={styles.label}>Set Live Activity subtitle:</Text>
        <Switch
              onValueChange={() => setPassSubtitle(previousState => !previousState)}
              value={passSubtitle}
          />
      </View>
      <TextInput
        style={passSubtitle ? styles.input : styles.diabledInput}
        onChangeText={onChangeSubtitle}
        placeholder="Live activity title"
        value={subtitle}
        editable={passSubtitle}
      />
      <View style={styles.labelWithSwitch}>
        <Text style={styles.label}>Set Live Activity image:</Text>
        <Switch
              onValueChange={() => setPassImage(previousState => !previousState)}
              value={passImage}
          />
      </View>
      <TextInput
        style={passImage ? styles.input : styles.diabledInput}
        onChangeText={onChangeImageName}
        autoCapitalize="none"
        placeholder="Live activity image"
        value={imageName}
        editable={passImage}
      />
      { Platform.OS === "ios" && (
        <>
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Set Live Activity timer:</Text>
          <Switch
                onValueChange={() => setPassDate(previousState => !previousState)}
                value={passDate}
            />
        </View>
          <View style={styles.timerControlsContainer}>
        { passDate && (
          <RNDateTimePicker
            value={date}
            mode="time"
            onChange={(event, date) => {
              date && setDate(date);
            }}
            minimumDate={new Date(Date.now() + 60 * 1000)}
          />
        )}
        </View>
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>{"Timer shown as text:"}</Text>
            <Switch
                onValueChange={(previousState) => previousState ? setTimerType("digital") : setTimerType("circular")}
                value={timerType == "digital"}
            />
        </View>
        </>
      )}
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
    marginBottom: 15,
    width: "90%",
    alignItems: "center",
    justifyContent: "center",
  },
  buttonsContainer: {
    padding: 30,
  },
  label: {
    width: "90%",
    fontSize: 17,
  },
  labelWithSwitch: {
    flexDirection: 'row',
    width: "90%",
    paddingEnd: 15,
  },
  input: {
    height: 45,
    width: "90%",
    marginVertical: 12,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 10,
    padding: 10,
  },
  diabledInput: {
    height: 45,
    width: "90%",
    margin: 12,
    borderWidth: 1,
    borderColor: "#DEDEDE",
    backgroundColor: "#ECECEC",
    color: "gray",
    borderRadius: 10,
    padding: 10,
  },
  timerCheckboxContainer: {
    alignItems: "flex-start",
    width: "90%",
    justifyContent: "center",
  },
});
