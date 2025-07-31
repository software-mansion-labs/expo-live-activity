import { useNavigation } from "@react-navigation/native";
import * as React from "react";
import { Button, Text, View } from "react-native";

export default function HomeScreen() {
  const navigation = useNavigation();

  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
      <Text>Home Screen</Text>
      <Button
        title="Create Live Activity"
        onPress={() => {
          navigation.navigate("CreateLiveActivity");
        }}
      />
    </View>
  );
}
