import { registerWebModule, NativeModule } from 'expo';

import { ExpoLiveActivityModuleEvents } from './ExpoLiveActivity.types';

class ExpoLiveActivityModule extends NativeModule<ExpoLiveActivityModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(ExpoLiveActivityModule, 'ExpoLiveActivityModule');
