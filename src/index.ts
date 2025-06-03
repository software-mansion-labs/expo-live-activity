import ExpoLiveActivityModule from './ExpoLiveActivityModule';

export type LiveActivityState = {
  title: string,
  subtitle: string,
  // date: string
};

export function hello(): string {
  return ExpoLiveActivityModule.hello();
}

export function startActivity(state: LiveActivityState): string {
  return ExpoLiveActivityModule.startActivity(state);
}
