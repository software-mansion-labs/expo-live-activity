import RNDateTimePicker from '@react-native-community/datetimepicker'
import type { LiveActivityConfig, LiveActivityState } from 'expo-live-activity'
import * as LiveActivity from 'expo-live-activity'
import { useCallback, useState } from 'react'
import { Button, Keyboard, Platform, ScrollView, StyleSheet, Switch, Text, TextInput, View } from 'react-native'

const dynamicIslandImageName = 'logo-island'
const toggle = (previousState: boolean) => !previousState

export default function CreateLiveActivityScreen() {
  const [activityId, setActivityID] = useState<string | null>()
  const [title, onChangeTitle] = useState('Title')
  const [subtitle, onChangeSubtitle] = useState('This is a subtitle')
  const [imageName, onChangeImageName] = useState('logo')
  const [date, setDate] = useState(new Date())
  const [isTimerTypeDigital, setTimerTypeDigital] = useState(false)
  const [progress, setProgress] = useState('0.5')
  const [passSubtitle, setPassSubtitle] = useState(true)
  const [passImage, setPassImage] = useState(true)
  const [passDate, setPassDate] = useState(true)
  const [passProgress, setPassProgress] = useState(false)

  const onChangeProgress = useCallback(
    (text: string) => {
      // Allow only numbers and dot
      if (/^\d*\.?\d*$/.test(text)) {
        // Allow only one dot or comma
        const dotCount = (text.match(/\./g) || []).length
        if (dotCount <= 1) {
          // Allow only numbers between 0 and 1
          const number = parseFloat(text)
          if (number >= 0 && number <= 1) {
            setProgress(text)
          } else if (text === '') {
            setProgress('')
          }
        }
      }
    },
    [setProgress]
  )

  const activityIdState = activityId ? `Activity ID: ${activityId}` : 'No active activity'
  console.log(activityIdState)

  const startActivity = () => {
    Keyboard.dismiss()
    const progressState = passDate
      ? {
          date: passDate ? date.getTime() : undefined,
        }
      : {
          progress: passProgress ? parseFloat(progress) : undefined,
        }

    const state: LiveActivityState = {
      title,
      subtitle: passSubtitle ? subtitle : undefined,
      progressBar: progressState,
      imageName: passImage ? imageName : undefined,
      dynamicIslandImageName,
    }

    try {
      const id = LiveActivity.startActivity(state, {
        ...activityConfig,
        timerType: isTimerTypeDigital ? 'digital' : 'circular',
      })
      if (id) setActivityID(id)
    } catch (e) {
      console.error('Starting activity failed! ' + e)
    }
  }

  const stopActivity = () => {
    const state: LiveActivityState = {
      title,
      subtitle,
      progressBar: {
        progress: 0,
      },
      imageName,
      dynamicIslandImageName,
    }
    try {
      activityId && LiveActivity.stopActivity(activityId, state)
      setActivityID(null)
    } catch (e) {
      console.error('Stopping activity failed! ' + e)
    }
  }

  const updateActivity = () => {
    const progressState = passDate
      ? {
          date: passDate ? date.getTime() : undefined,
        }
      : {
          progress: passProgress ? parseFloat(progress) : undefined,
        }

    const state: LiveActivityState = {
      title,
      subtitle: passSubtitle ? subtitle : undefined,
      progressBar: progressState,
      imageName: passImage ? imageName : undefined,
      dynamicIslandImageName,
    }
    try {
      activityId && LiveActivity.updateActivity(activityId, state)
    } catch (e) {
      console.error('Updating activity failed! ' + e)
    }
  }

  return (
    <ScrollView style={styles.scroll}>
      <View style={styles.container}>
        <Text style={styles.label}>Set Live Activity title:</Text>
        <TextInput style={styles.input} onChangeText={onChangeTitle} placeholder="Live activity title" value={title} />
        <View style={styles.labelWithSwitch}>
          <Text style={styles.label}>Set Live Activity subtitle:</Text>
          <Switch onValueChange={() => setPassSubtitle(toggle)} value={passSubtitle} />
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
          <Switch onValueChange={() => setPassImage(toggle)} value={passImage} />
        </View>
        <TextInput
          style={passImage ? styles.input : styles.diabledInput}
          onChangeText={onChangeImageName}
          autoCapitalize="none"
          placeholder="Live activity image"
          value={imageName}
          editable={passImage}
        />
        {Platform.OS === 'ios' && (
          <>
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Set Live Activity timer:</Text>
              <Switch
                onValueChange={() => {
                  setPassDate(toggle)
                  setPassProgress(false)
                }}
                value={passDate}
              />
            </View>
            <View style={styles.timerControlsContainer}>
              {passDate && (
                <RNDateTimePicker
                  value={date}
                  mode="time"
                  onChange={(event, date) => {
                    date && setDate(date)
                  }}
                  minimumDate={new Date(Date.now() + 60 * 1000)}
                />
              )}
            </View>
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Timer shown as text:</Text>
              <Switch
                onValueChange={() => {
                  setTimerTypeDigital(toggle)
                  setPassProgress(false)
                }}
                value={isTimerTypeDigital}
              />
            </View>
            <View style={styles.spacer} />
            <View style={styles.labelWithSwitch}>
              <Text style={styles.label}>Show progress:</Text>
              <Switch
                onValueChange={() => {
                  setPassProgress(toggle)
                  setPassDate(false)
                  setTimerTypeDigital(false)
                }}
                value={passProgress}
              />
            </View>
            <TextInput
              style={passProgress ? styles.input : styles.diabledInput}
              onChangeText={onChangeProgress}
              keyboardType="numeric"
              placeholder="Progress (0-1)"
              value={progress.toString()}
              editable={passProgress}
            />
          </>
        )}
        <View style={styles.buttonsContainer}>
          <Button title="Start Activity" onPress={startActivity} disabled={title === '' || !!activityId} />
          <Button title="Stop Activity" onPress={stopActivity} disabled={!activityId} />
          <Button title="Update Activity" onPress={updateActivity} disabled={!activityId} />
        </View>
      </View>
    </ScrollView>
  )
}

const activityConfig: LiveActivityConfig = {
  backgroundColor: '001A72',
  titleColor: 'EBEBF0',
  subtitleColor: '#FFFFFF75',
  progressViewTint: '38ACDD',
  progressViewLabelColor: '#FFFFFF',
  deepLinkUrl: '/dashboard',
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scroll: {
    flex: 1,
  },
  timerControlsContainer: {
    flexDirection: 'row',
    marginTop: 15,
    marginBottom: 15,
    width: '90%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonsContainer: {
    padding: 30,
  },
  label: {
    width: '90%',
    fontSize: 17,
  },
  labelWithSwitch: {
    flexDirection: 'row',
    width: '90%',
    paddingEnd: 15,
  },
  input: {
    height: 45,
    width: '90%',
    marginVertical: 12,
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 10,
    padding: 10,
  },
  diabledInput: {
    height: 45,
    width: '90%',
    margin: 12,
    borderWidth: 1,
    borderColor: '#DEDEDE',
    backgroundColor: '#ECECEC',
    color: 'gray',
    borderRadius: 10,
    padding: 10,
  },
  timerCheckboxContainer: {
    alignItems: 'flex-start',
    width: '90%',
    justifyContent: 'center',
  },
  spacer: {
    height: 16,
  },
})
