import {
  type LiveActivityConfig,
  type LiveActivityState,
  startActivity,
  stopActivity,
  updateActivity,
} from 'expo-live-activity'
import { useState } from 'react'
import { colors } from '../constants'

const activityConfig: LiveActivityConfig = {
  backgroundColor: colors.primary,
  titleColor: '#FFFFFF',
  subtitleColor: '#FFFFFF75',
  progressViewTint: '#FFFFFF75',
  progressViewLabelColor: '#FFFFFF',
  deepLinkUrl: '/order',
  timerType: 'digital',
}

const title = 'Pizza Palace Order'
const subtitle = 'Your pizza is on the way!'
const imageName = 'logo'
const dynamicIslandImageName = 'logo-island'
const createDate = (minutes: number) => Date.now() + 1000 * 60 * minutes

export default function useLiveActivity() {
  const [activityId, setActivityId] = useState<string>()

  return {
    start: () => {
      if (activityId) return

      const state: LiveActivityState = {
        title,
        subtitle,
        date: createDate(3),
        imageName,
        dynamicIslandImageName,
      }

      try {
        const id = startActivity(state, activityConfig)

        setActivityId(id)
      } catch (e) {
        console.error('Starting activity failed! ' + e)
      }
    },
    stop: () => {
      const state: LiveActivityState = {
        title,
        subtitle,
        date: createDate(3),
        imageName,
        dynamicIslandImageName,
      }
      try {
        activityId && stopActivity(activityId, state)
        setActivityId(undefined)
      } catch (e) {
        console.error('Stopping activity failed! ' + e)
      }
    },
    update: () => {
      if (!activityId) return

      const state: LiveActivityState = {
        title,
        subtitle,
        date: createDate(3),
        imageName,
        dynamicIslandImageName,
      }
      try {
        updateActivity(activityId, state)
      } catch (e) {
        console.error('Updating activity failed! ' + e)
      }
    },
  }
}
