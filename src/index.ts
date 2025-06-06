import ExpoLiveActivityModule from './ExpoLiveActivityModule';

export type LiveActivityState = {
  title: string,
  subtitle: string,
  date: number
};

export function startActivity(state: LiveActivityState): string {
  return ExpoLiveActivityModule.startActivity(state);
}

export function stopActivity(id: String, state: LiveActivityState): string {
  return ExpoLiveActivityModule.stopActivity(id, state);
}
