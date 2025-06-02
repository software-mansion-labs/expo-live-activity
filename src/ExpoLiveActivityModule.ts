import { NativeModule, requireNativeModule } from 'expo';

import { ExpoLiveActivityModuleEvents } from './ExpoLiveActivity.types';

declare class ExpoLiveActivityModule extends NativeModule<ExpoLiveActivityModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoLiveActivityModule>('ExpoLiveActivity');
