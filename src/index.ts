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

export type Padding =
  | {
      top?: number
      bottom?: number
      left?: number
      right?: number
      vertical?: number
      horizontal?: number
    }
  | number

export type ImagePosition = 'left' | 'right' | 'leftStretch' | 'rightStretch'

export type ImageAlign = 'top' | 'center' | 'bottom'

export type ImageDimension = number | `${number}%`
export type ImageSize = {
  width: ImageDimension
  height: ImageDimension
}

export type ImageContentFit = 'cover' | 'contain' | 'fill' | 'none' | 'scale-down'

export type LiveActivityConfig = {
  backgroundColor?: string
  titleColor?: string
  subtitleColor?: string
  progressViewTint?: string
  progressViewLabelColor?: string
  deepLinkUrl?: string
  timerType?: DynamicIslandTimerType
  padding?: Padding
  imagePosition?: ImagePosition
  imageAlign?: ImageAlign
  imageSize?: ImageSize
  contentFit?: ImageContentFit
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

function normalizeConfig(config?: LiveActivityConfig) {
  if (config === undefined) return config

  const { padding, imageSize, ...base } = config
  type NormalizedConfig = LiveActivityConfig & {
    paddingDetails?: Padding
    imageWidth?: number
    imageHeight?: number
    imageWidthPercent?: number
    imageHeightPercent?: number
  }
  const normalized: NormalizedConfig = { ...base }

  // Normalize padding: keep number in padding, object in paddingDetails
  if (typeof padding === 'number') {
    normalized.padding = padding
  } else if (typeof padding === 'object') {
    normalized.paddingDetails = padding
  }

  // Normalize imageSize: object with width/height each a number (points) or percent string like '50%'
  if (imageSize) {
    const regExp = /^(100(?:\.0+)?|\d{1,2}(?:\.\d+)?)%$/ // Matches 0.0% to 100.0%

    const { width, height } = imageSize

    if (typeof width === 'number') {
      normalized.imageWidth = width
    } else if (typeof width === 'string') {
      const match = width.trim().match(regExp)
      if (match) {
        normalized.imageWidthPercent = Number(match[1])
      } else {
        throw new Error('imageSize.width percent string must be in format "0%" to "100%"')
      }
    }

    if (typeof height === 'number') {
      normalized.imageHeight = height
    } else if (typeof height === 'string') {
      const match = height.trim().match(regExp)
      if (match) {
        normalized.imageHeightPercent = Number(match[1])
      } else {
        throw new Error('imageSize.height percent string must be in format "0%" to "100%"')
      }
    }
  }

  return normalized
}

/**
 * @param {LiveActivityState} state The state for the live activity.
 * @param {LiveActivityConfig} config Live activity config object.
 * @returns {string} The identifier of the started activity or undefined if creating live activity failed.
 */
export function startActivity(state: LiveActivityState, config?: LiveActivityConfig): Voidable<string> {
  if (assertIOS('startActivity')) return ExpoLiveActivityModule.startActivity(state, normalizeConfig(config))
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function stopActivity(id: string, state: LiveActivityState) {
  if (assertIOS('stopActivity')) return ExpoLiveActivityModule.stopActivity(id, state)
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function updateActivity(id: string, state: LiveActivityState) {
  if (assertIOS('updateActivity')) return ExpoLiveActivityModule.updateActivity(id, state)
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
