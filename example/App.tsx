import * as React from "react";
import { useEffect } from "react";
import * as LiveActivity from "expo-live-activity";
import Navigation from "./Navigation";

export default function App() {
  useEffect(() => {
    const updateTokenSubscription = LiveActivity.addActivityTokenListener(
      ({ activityID: newActivityID, activityPushToken: newToken }) => {
        console.log(`Activity id: ${newActivityID}, token: ${newToken}`);
      },
    );
    const startTokenSubscription = LiveActivity.addActivityPushToStartTokenListener(
      ({ activityPushToStartToken: newActivityPushToStartToken }) => {
        console.log(`Push to start token: ${newActivityPushToStartToken}`);
      },
    );

    LiveActivity.observePushToStartToken();
    return () => {
      updateTokenSubscription?.remove();
      startTokenSubscription?.remove();
    };
  }, []);

  return <Navigation />;
}
