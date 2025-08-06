import { useNavigation } from "@react-navigation/native";
import { useLinkingURL } from "expo-linking";
import * as React from "react";
import { Button, Text, View } from "react-native";

export default function HomeScreen() {
  const navigation = useNavigation();
  const url = useLinkingURL();

  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
      <Text>Home Screen</Text>
      <Text>URL: {url}</Text>
      <Button
        title="Create Live Activity"
        onPress={() => {
          navigation.navigate("CreateLiveActivity");
        }}
      />
    </View>
  );
}
