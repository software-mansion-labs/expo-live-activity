import * as React from "react";
import { useEffect } from "react";
import * as LiveActivity from "expo-live-activity";
import Navigation from "./Navigation";

export default function App() {
  useEffect(() => {
    const subscription = LiveActivity.addActivityTokenListener(
      ({ activityID: newActivityID, activityPushToken: newToken }) => {
        console.log(`Activity id: ${newActivityID}, token: ${newToken}`);
      },
    );

    return () => subscription.remove();
  }, []);

  return <Navigation />;
}
