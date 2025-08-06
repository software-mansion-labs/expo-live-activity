import ExpoLiveActivityModule from "./ExpoLiveActivityModule";
import { Platform } from "react-native";
import { EventSubscription } from 'expo-modules-core';

export type DynamicIslandTimerType = 'circular' | 'digital'

export type LiveActivityState = {
  title: string;
  subtitle?: string;
  date?: number;
  imageName?: string;
  dynamicIslandImageName?: string;
};

export type LiveActivityConfig = {
  backgroundColor?: string;
  titleColor?: string;
  subtitleColor?: string;
  progressViewTint?: string;
  progressViewLabelColor?: string;
  deepLinkUrl?: string;
  timerType?: DynamicIslandTimerType;
};

export type ActivityTokenReceivedEvent = {
  activityID: string;
  activityPushToken: string;
};

export type LiveActivityModuleEvents = {
  onTokenReceived: (params: ActivityTokenReceivedEvent) => void;
};

/**
 * @param {LiveActivityState} state The state for the live activity.
 * @param {LiveActivityConfig} config Live activity config object.
 * @returns {string} The identifier of the started activity or undefined if creating live activity failed.
 */
export function startActivity(state: LiveActivityState, config?: LiveActivityConfig): string | undefined {
  if (Platform.OS !== "ios") {
    console.error("startActivity is only available on iOS");
    return undefined
  }
  try {
    return ExpoLiveActivityModule.startActivity(state, config);
  } catch (error) {
    console.error(`startActivity failed with an error: ${error}`);
    return undefined
  }
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function stopActivity(id: string, state: LiveActivityState) {
  if (Platform.OS !== "ios") {
    console.error("stopActivity is only available on iOS");
  }
  try {
    return ExpoLiveActivityModule.stopActivity(id, state);
  } catch (error) {
    console.error(`stopActivity failed with an error: ${error}`);
  }
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function updateActivity(id: string, state: LiveActivityState) {
  if (Platform.OS !== "ios") {
    console.error("updateActivity is only available on iOS");
  }
  try {
    return ExpoLiveActivityModule.updateActivity(id, state);
  } catch (error) {
    console.error(`updateActivity failed with an error: ${error}`);
  }
}

export function addActivityTokenListener(listener: (event: ActivityTokenReceivedEvent) => void): EventSubscription | undefined {
  if (Platform.OS !== "ios") {
    console.error("addActivityTokenListener is only available on iOS");
    return undefined
  }
  return ExpoLiveActivityModule.addListener('onTokenReceived', listener);
}

export function observePushToStart() {
  if (Platform.OS !== "ios") {
    throw new Error("updateActivity is only available on iOS");
  }
  return ExpoLiveActivityModule.observePushToStart();
}
