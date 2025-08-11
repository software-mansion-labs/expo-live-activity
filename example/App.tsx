import * as React from 'react'
import { useEffect } from 'react'
import * as Linking from 'expo-linking'
import * as LiveActivity from 'expo-live-activity'
import Navigation from './Navigation'

const prefix = Linking.createURL('')

export default function App() {
  const url = Linking.useLinkingURL()
  const linking = {
    enabled: 'auto' as const,
    prefixes: [prefix],
  }

  useEffect(() => {
    const subscription = LiveActivity.addActivityTokenListener(
      ({ activityID: newActivityID, activityPushToken: newToken }) => {
        console.log(`Activity id: ${newActivityID}, token: ${newToken}`)
      },
    )

    return () => subscription?.remove()
  }, [])

  return <Navigation linking={linking} />
}
