import { useLinkingURL } from 'expo-linking'
import * as React from 'react'
import { StyleSheet, Text } from 'react-native'

import CreateLiveActivityScreen from './CreateLiveActivityScreen'

export default function HomeScreen() {
  const url = useLinkingURL()

  return (
    <>
      <CreateLiveActivityScreen />
      <Text style={styles.urlText}>URL: {url}</Text>
    </>
  )
}

const styles = StyleSheet.create({
  urlText: {
    padding: 20,
  },
})
