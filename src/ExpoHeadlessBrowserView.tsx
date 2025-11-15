import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoHeadlessBrowserViewProps } from './ExpoHeadlessBrowser.types';

const NativeView: React.ComponentType<ExpoHeadlessBrowserViewProps> =
  requireNativeView('ExpoHeadlessBrowser');

export default function ExpoHeadlessBrowserView(props: ExpoHeadlessBrowserViewProps) {
  return <NativeView {...props} />;
}
