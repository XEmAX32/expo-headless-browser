import { registerWebModule, NativeModule } from 'expo';

import { ExpoHeadlessBrowserModuleEvents } from './ExpoHeadlessBrowser.types';

class ExpoHeadlessBrowserModule extends NativeModule<ExpoHeadlessBrowserModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(ExpoHeadlessBrowserModule, 'ExpoHeadlessBrowserModule');
