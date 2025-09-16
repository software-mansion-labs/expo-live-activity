import { EventSubscription } from 'expo-modules-core'
import { Platform } from 'react-native'

import ExpoLiveActivityModule from './ExpoLiveActivityModule'

type Voidable<T> = T | void

export type DynamicIslandTimerType = 'circular' | 'digital'

type ProgressBarType =
  | {
      date?: number
      progress?: undefined
    }
  | {
      date?: undefined
      progress?: number
    }

export type LiveActivityState = {
  title: string
  subtitle?: string
  progressBar?: ProgressBarType
  imageName?: string
  dynamicIslandImageName?: string
}

export type NativeLiveActivityState = {
  title: string
  subtitle?: string
  date?: number
  progress?: number
  imageName?: string
  dynamicIslandImageName?: string
}

export type LiveActivityConfig = {
  backgroundColor?: string
  titleColor?: string
  subtitleColor?: string
  progressViewTint?: string
  progressViewLabelColor?: string
  deepLinkUrl?: string
  timerType?: DynamicIslandTimerType
}

export type ActivityTokenReceivedEvent = {
  activityID: string
  activityName: string
  activityPushToken: string
}

export type ActivityPushToStartTokenReceivedEvent = {
  activityPushToStartToken: string
}

type ActivityState = 'active' | 'dismissed' | 'pending' | 'stale' | 'ended'

export type ActivityUpdateEvent = {
  activityID: string
  activityName: string
  activityState: ActivityState
}

export type LiveActivityModuleEvents = {
  onTokenReceived: (params: ActivityTokenReceivedEvent) => void
  onPushToStartTokenReceived: (params: ActivityPushToStartTokenReceivedEvent) => void
  onStateChange: (params: ActivityUpdateEvent) => void
}

function assertIOS(name: string) {
  const isIOS = Platform.OS === 'ios'

  if (!isIOS) console.error(`${name} is only available on iOS`)

  return isIOS
}

const mapStateToNativeState = (state: LiveActivityState): NativeLiveActivityState => {
  if (state.progressBar?.date) {
    return {
      title: state.title,
      subtitle: state.subtitle,
      date: state.progressBar.date,
      imageName: state.imageName,
      dynamicIslandImageName: state.dynamicIslandImageName,
    }
  } else if (state.progressBar?.progress) {
    return {
      title: state.title,
      subtitle: state.subtitle,
      progress: state.progressBar.progress,
      imageName: state.imageName,
      dynamicIslandImageName: state.dynamicIslandImageName,
    }
  }
  return {
    title: state.title,
    subtitle: state.subtitle,
    imageName: state.imageName,
    dynamicIslandImageName: state.dynamicIslandImageName,
  }
}

/**
 * @param {LiveActivityState} state The state for the live activity.
 * @param {LiveActivityConfig} config Live activity config object.
 * @returns {string} The identifier of the started activity or undefined if creating live activity failed.
 */
export function startActivity(state: LiveActivityState, config?: LiveActivityConfig): Voidable<string> {
  if (assertIOS('startActivity')) return ExpoLiveActivityModule.startActivity(mapStateToNativeState(state), config)
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function stopActivity(id: string, state: LiveActivityState) {
  if (assertIOS('stopActivity')) return ExpoLiveActivityModule.stopActivity(id, mapStateToNativeState(state))
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function updateActivity(id: string, state: LiveActivityState) {
  if (assertIOS('updateActivity')) return ExpoLiveActivityModule.updateActivity(id, mapStateToNativeState(state))
}

export function addActivityTokenListener(
  listener: (event: ActivityTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityTokenListener')) return ExpoLiveActivityModule.addListener('onTokenReceived', listener)
}

export function addActivityPushToStartTokenListener(
  listener: (event: ActivityPushToStartTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityPushToStartTokenListener'))
    return ExpoLiveActivityModule.addListener('onPushToStartTokenReceived', listener)
}

export function addActivityUpdatesListener(
  listener: (event: ActivityUpdateEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityUpdatesListener')) return ExpoLiveActivityModule.addListener('onStateChange', listener)
}
