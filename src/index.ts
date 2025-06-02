// Reexport the native module. On web, it will be resolved to ExpoLiveActivityModule.web.ts
// and on native platforms to ExpoLiveActivityModule.ts
export { default } from './ExpoLiveActivityModule';
export { default as ExpoLiveActivityView } from './ExpoLiveActivityView';
export * from  './ExpoLiveActivity.types';
