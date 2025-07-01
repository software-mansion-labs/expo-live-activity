import ExpoLiveActivityModule from './ExpoLiveActivityModule';
import { Platform } from 'react-native';

export type LiveActivityState = {
  title: string,
  subtitle: string,
  date: number
};

/**
 * @param {LiveActivityState} state The state for the live activity.
 * @returns {string} The identifier of the started activity.
 * @throws {Error} when function is called on platform different than iOS.
 */
export function startActivity(state: LiveActivityState): string {
  if (Platform.OS !== 'ios') {
    throw new Error('startActivity is only available on iOS');
  }
  return ExpoLiveActivityModule.startActivity(state);
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 * @returns {string} The identifier of the stopped activity.
 * @throws {Error} If not on iOS.
 */
export function stopActivity(id: string, state: LiveActivityState): string {
  if (Platform.OS !== 'ios') {
    throw new Error('stopActivity is only available on iOS');
  }
  return ExpoLiveActivityModule.stopActivity(id, state);
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 * @returns {string} The identifier of the updated activity.
 * @throws {Error} If not on iOS.
 */
export function updateActivity(id: string, state: LiveActivityState): string {
  if (Platform.OS !== 'ios') {
    throw new Error('updateActivity is only available on iOS');
  }
  return ExpoLiveActivityModule.updateActivity(id, state);
}
