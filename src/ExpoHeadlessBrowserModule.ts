import { NativeModule, requireNativeModule } from 'expo';

import { ExpoHeadlessBrowserModuleEvents } from './ExpoHeadlessBrowser.types';

declare class ExpoHeadlessBrowserModule extends NativeModule<ExpoHeadlessBrowserModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoHeadlessBrowserModule>('ExpoHeadlessBrowser');
