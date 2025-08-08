import * as React from 'react'
import { useEffect } from 'react'
import * as Linking from 'expo-linking'
import * as LiveActivity from 'expo-live-activity'
import Navigation from './Navigation'

// widget przesyła tylko ścieżkę `/order` jako url, natomiast auto linkowana jest tylko schema `expo-live-activity-example://order`
const prefix = Linking.createURL('')
console.log('prefix', prefix)
export default function App() {
  const url = Linking.useLinkingURL()
  console.log('url', url)
  const linking = {
    enabled: 'auto' as const,
    prefixes: [prefix, 'com.swmansion.expoliveactivity.example://'],
  }

  useEffect(() => {
    const subscription = LiveActivity.addActivityTokenListener(
      ({ activityID: newActivityID, activityPushToken: newToken }) => {
        console.log(`Activity id: ${newActivityID}, token: ${newToken}`)
      },
    )

    return () => subscription.remove()
  }, [])

  return <Navigation linking={linking} />
}
