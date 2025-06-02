import * as React from 'react';

import { ExpoLiveActivityViewProps } from './ExpoLiveActivity.types';

export default function ExpoLiveActivityView(props: ExpoLiveActivityViewProps) {
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
