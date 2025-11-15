import * as React from 'react';

import { ExpoHeadlessBrowserViewProps } from './ExpoHeadlessBrowser.types';

export default function ExpoHeadlessBrowserView(props: ExpoHeadlessBrowserViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
