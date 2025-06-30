import ExpoLiveActivityModule from './ExpoLiveActivityModule';

export type LiveActivityState = {
  title: string,
  subtitle: string,
  date: number
};

export type LiveActivityStyles = {
  backgroundColor: string
  titleColor: string
  subtitleColor: string
  progressViewTint: string
  progressViewLabelColor: string
};

export function startActivity(state: LiveActivityState, styles: LiveActivityStyles): string {
  return ExpoLiveActivityModule.startActivity(state, styles);
}

export function stopActivity(id: String, state: LiveActivityState): string {
  return ExpoLiveActivityModule.stopActivity(id, state);
}

export function updateActivity(id: String, state: LiveActivityState): string {
  return ExpoLiveActivityModule.updateActivity(id, state);
}
