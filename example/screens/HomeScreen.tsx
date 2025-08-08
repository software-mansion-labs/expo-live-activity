import { useNavigation } from "@react-navigation/native";
import { useLinkingURL } from "expo-linking";
import * as React from "react";
import { StyleSheet, Text, View } from "react-native";
import CreateLiveActivityScreen from "./CreateLiveActivityScreen";

export default function HomeScreen() {
  const navigation = useNavigation();
  const url = useLinkingURL();

  return (
    <>
      <CreateLiveActivityScreen />
      <Text style= {styles.urlText }>URL: {url}</Text>
    </>
  );
}

const styles = StyleSheet.create({
  urlText: {
    padding: 20,
  },
})