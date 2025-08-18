import * as LiveActivity from 'expo-live-activity'
import { useEffect } from 'react'

import Navigation from './Navigation'

export default function App() {
  useEffect(() => {
    const updateTokenSubscription = LiveActivity.addActivityTokenListener(
      ({ activityID: newActivityID, activityName: newName, activityPushToken: newToken }) => {
        console.log(`Activity id: ${newActivityID}, activity name: ${newName}, token: ${newToken}`)
      }
    )
    const startTokenSubscription = LiveActivity.addActivityPushToStartTokenListener(
      ({ activityPushToStartToken: newActivityPushToStartToken }) => {
        console.log(`Push to start token: ${newActivityPushToStartToken}`)
      }
    )

    const updatesSubscription = LiveActivity.addActivityUpdatesListener(({ activityState }) => {
      console.log(`Activity state: ${activityState}`)
    })

    return () => {
      updateTokenSubscription?.remove()
      startTokenSubscription?.remove()
      updatesSubscription?.remove()
    }
  }, [])

  return <Navigation />
}
