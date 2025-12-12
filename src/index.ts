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
  /** Custom fields for Dynamic Island DSL bindings */
  custom?: Record<string, string | number | boolean>
}

export type NativeLiveActivityState = {
  title: string
  subtitle?: string
  date?: number
  progress?: number
  imageName?: string
  dynamicIslandImageName?: string
  custom?: Record<string, string | number | boolean>
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
  /** Dynamic Island customization config */
  dynamicIsland?: DynamicIslandConfig
}

export type ActivityTokenReceivedEvent = {
  activityID: string
  activityName: string
  activityPushToken: string
}

export type ActivityPushToStartTokenReceivedEvent = {
  activityPushToStartToken: string | null
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
  onButtonPress: (params: ButtonPressEvent) => void
}

// ============================================================================
// Dynamic Island DSL Types
// ============================================================================

/**
 * Text element for Dynamic Island
 */
export type DIText = {
  type: 'text'
  /** Static text or "$fieldName" for dynamic binding to ContentState */
  value: string
  font?: 'caption' | 'caption2' | 'footnote' | 'body' | 'subheadline' | 'headline' | 'title3' | 'title2' | 'title'
  weight?: 'ultraLight' | 'thin' | 'light' | 'regular' | 'medium' | 'semibold' | 'bold' | 'heavy' | 'black'
  /** Hex color string */
  color?: string
  /** Minimum scale factor for text (0.0 - 1.0) */
  minimumScaleFactor?: number
}

/**
 * SF Symbol element for Dynamic Island
 */
export type DISFSymbol = {
  type: 'sfSymbol'
  /** SF Symbol name, e.g. "car.fill", "star", "timer" */
  name: string
  /** Hex color string */
  color?: string
  /** Symbol size in points */
  size?: number
  weight?: 'ultraLight' | 'thin' | 'light' | 'regular' | 'medium' | 'semibold' | 'bold' | 'heavy' | 'black'
  renderingMode?: 'monochrome' | 'hierarchical' | 'palette' | 'multicolor'
  /** Secondary colors for palette mode */
  secondaryColor?: string
  tertiaryColor?: string
}

/**
 * Image element for Dynamic Island
 */
export type DIImage = {
  type: 'image'
  /** Asset name, URL, or "$fieldName" for dynamic binding */
  source: string
  /** Width in points */
  width?: number
  /** Height in points */
  height?: number
  /** Content mode */
  contentMode?: 'fit' | 'fill'
  /** Tint color (hex) */
  tint?: string
}

/**
 * Progress indicator element
 */
export type DIProgress = {
  type: 'progress'
  /** Binding to progress value, e.g. "$progress" */
  value: string
  style?: 'linear' | 'circular'
  /** Tint color (hex) */
  tint?: string
  /** Show label */
  showLabel?: boolean
}

/**
 * Gauge element for displaying values
 */
export type DIGauge = {
  type: 'gauge'
  /** Binding to gauge value, e.g. "$progress" */
  value: string
  style?: 'circular' | 'linear' | 'capacityCircular'
  /** Tint color (hex) */
  tint?: string
  /** Minimum value (default 0) */
  min?: number
  /** Maximum value (default 1) */
  max?: number
  /** Label text */
  label?: string
}

/**
 * Timer element for countdown/countup displays
 */
export type DITimer = {
  type: 'timer'
  /** Binding to end date in milliseconds, e.g. "$timerEndDate" */
  endDate: string
  style?: 'compact' | 'offset' | 'relative' | 'timer'
  /** Tint color (hex) */
  tint?: string
  /** Count down instead of up */
  countsDown?: boolean
}

/**
 * Interactive button element (iOS 17+ only)
 */
export type DIButton = {
  type: 'button'
  /** Unique identifier for handling button press events */
  id: string
  /** Button label - text string or SF Symbol */
  label: string | DISFSymbol
  style?: 'plain' | 'bordered' | 'borderedProminent'
  /** Tint color (hex) */
  tint?: string
}

/**
 * Horizontal stack container
 */
export type DIHStack = {
  type: 'hstack'
  children: DIElement[]
  /** Spacing between children in points */
  spacing?: number
  alignment?: 'top' | 'center' | 'bottom'
}

/**
 * Vertical stack container
 */
export type DIVStack = {
  type: 'vstack'
  children: DIElement[]
  /** Spacing between children in points */
  spacing?: number
  alignment?: 'leading' | 'center' | 'trailing'
}

/**
 * Z-axis stack container (overlapping views)
 */
export type DIZStack = {
  type: 'zstack'
  children: DIElement[]
  alignment?: 'center' | 'topLeading' | 'top' | 'topTrailing' | 'leading' | 'trailing' | 'bottomLeading' | 'bottom' | 'bottomTrailing'
}

/**
 * Flexible spacer element
 */
export type DISpacer = {
  type: 'spacer'
  /** Minimum length in points */
  minLength?: number
}

/**
 * Union type of all Dynamic Island elements
 */
export type DIElement =
  | DIText
  | DISFSymbol
  | DIImage
  | DIProgress
  | DIGauge
  | DITimer
  | DIButton
  | DIHStack
  | DIVStack
  | DIZStack
  | DISpacer

/**
 * Configuration for compact Dynamic Island presentation (pill mode)
 */
export type DICompactConfig = {
  /** Content for the leading side (left of camera) */
  leading?: DIElement
  /** Content for the trailing side (right of camera) */
  trailing?: DIElement
}

/**
 * Configuration for minimal Dynamic Island presentation (multiple activities)
 */
export type DIMinimalConfig = {
  /** Single content element for minimal view */
  content: DIElement
}

/**
 * Configuration for expanded Dynamic Island presentation (long-press)
 */
export type DIExpandedConfig = {
  /** Content for leading region (left of camera) */
  leading?: DIElement
  /** Priority for leading region (higher = more space) */
  leadingPriority?: number
  /** Content for trailing region (right of camera) */
  trailing?: DIElement
  /** Priority for trailing region */
  trailingPriority?: number
  /** Content for center region (below camera) */
  center?: DIElement
  /** Content for bottom region */
  bottom?: DIElement
}

/**
 * Full Dynamic Island configuration
 */
export type DynamicIslandConfig = {
  compact?: DICompactConfig
  minimal?: DIMinimalConfig
  expanded?: DIExpandedConfig
}

/**
 * Event emitted when a Dynamic Island button is pressed
 */
export type ButtonPressEvent = {
  activityId: string
  buttonId: string
}

function assertIOS(name: string) {
  const isIOS = Platform.OS === 'ios'

  if (!isIOS) console.error(`${name} is only available on iOS`)

  return isIOS
}

function normalizeConfig(config?: LiveActivityConfig) {
  if (config === undefined) return config

  const { padding, imageSize, dynamicIsland, ...base } = config
  type NormalizedConfig = Omit<LiveActivityConfig, 'dynamicIsland'> & {
    paddingDetails?: Padding
    imageWidth?: number
    imageHeight?: number
    imageWidthPercent?: number
    imageHeightPercent?: number
    /** JSON-encoded Dynamic Island config for native bridge */
    dynamicIslandJSON?: string
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

  // Serialize Dynamic Island config to JSON for native bridge
  if (dynamicIsland) {
    normalized.dynamicIslandJSON = JSON.stringify(dynamicIsland)
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

/**
 * @param {function} updateTokenListener The listener function that will be called when an update token is received.
 */
export function addActivityTokenListener(
  updateTokenListener: (event: ActivityTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityTokenListener'))
    return ExpoLiveActivityModule.addListener('onTokenReceived', updateTokenListener)
}

/**
 * Adds a listener that is called when a push-to-start token is received. Supported only on iOS > 17.2.
 * On earlier iOS versions, the listener will return null as a token.
 * @param {function} pushPushToStartTokenListener The listener function that will be called when the observer starts and then when a push-to-start token is received.
 */
export function addActivityPushToStartTokenListener(
  pushPushToStartTokenListener: (event: ActivityPushToStartTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityPushToStartTokenListener'))
    return ExpoLiveActivityModule.addListener('onPushToStartTokenReceived', pushPushToStartTokenListener)
}

/**
 * @param {function} statusListener The listener function that will be called when an activity status changes.
 */
export function addActivityUpdatesListener(
  statusListener: (event: ActivityUpdateEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityUpdatesListener'))
    return ExpoLiveActivityModule.addListener('onStateChange', statusListener)
}

/**
 * Adds a listener for button press events from Dynamic Island interactive buttons (iOS 17+).
 * @param {function} buttonPressListener The listener function that will be called when a button is pressed.
 */
export function addButtonPressListener(
  buttonPressListener: (event: ButtonPressEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addButtonPressListener'))
    return ExpoLiveActivityModule.addListener('onButtonPress', buttonPressListener)
}
