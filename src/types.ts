export type DynamicIslandTimerType = 'circular' | 'digital'

export type LiveActivityState = {
  title: string;
  subtitle?: string;
  date?: number;
  imageName?: string;
  dynamicIslandImageName?: string;
};

export type LiveActivityStyles = {
  backgroundColor?: string;
  titleColor?: string;
  subtitleColor?: string;
  progressViewTint?: string;
  progressViewLabelColor?: string;
  timerType?: DynamicIslandTimerType;
};

export type ActivityTokenReceivedEvent = {
  activityID: string;
  activityPushToken: string;
};

export type LiveActivityModuleEvents = {
  onTokenReceived: (params: ActivityTokenReceivedEvent) => void;
};
