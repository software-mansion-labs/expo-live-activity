> [!WARNING]  
> This library is in early development stage, breaking changes can be introduced in minor version upgrades.

# expo-live-activity

`expo-live-activity` is a React Native module designed for use with Expo to manage and display live activities on iOS devices exclusively. This module leverages the Live Activities feature introduced in iOS 16, allowing developers to deliver timely updates right on the lock screen.

## Features

- Start, update, and stop live activities directly from your React Native application.
- Easy integration with a comprehensive API.
- Custom image support within live activities with a pre-configured path.
- Listen and handle changes in push notification tokens associated with a live activity.

## Platform compatibility

**Note:** This module is intended for use on **iOS devices only**. The minimal iOS version that supports Live Activities is 16.2. When methods are invoked on platforms other than iOS or on older iOS versions, they will log an error, ensuring that they are used in the correct context.

## Installation

> [!NOTE]  
> The library isn't supported in Expo Go, to set it up correctly you need to use [Expo DevClient](https://docs.expo.dev/versions/latest/sdk/dev-client/) .
> To begin using `expo-live-activity`, follow the installation and configuration steps outlined below:

### Step 1: Installation

Run the following command to add the expo-live-activity module to your project:

```sh
npm install expo-live-activity
```

### Step 2: Config Plugin Setup

The module comes with a built-in config plugin that creates a target in iOS with all the necessary files. The images used in live activities should be added to a pre-defined folder in your assets directory:

1. **Add the config plugin to your app.json or app.config.js:**
   ```json
   {
     "expo": {
       "plugins": ["expo-live-activity"]
     }
   }
   ```
   If you want to update Live Acitivity with push notifications you can add option `"enablePushNotifications": true`:
   ```json
   {
     "expo": {
       "plugins": [
         [
           "expo-live-activity",
           {
             "enablePushNotifications": true
           }
         ]
       ]
     }
   }
   ```
2. **Assets configuration:**
   Place images intended for live activities in the `assets/liveActivity` folder. The plugin manages these assets automatically.

Then prebuild your app with:

```sh
npx expo prebuild --clean
```

### Step 3: Usage in Your React Native App

Import the functionalities provided by the `expo-live-activity` module in your JavaScript or TypeScript files:

```javascript
import * as LiveActivity from 'expo-live-activity'
```

## API

`expo-live-activity` module exports three primary functions to manage live activities:

### Managing Live Activities

- **`startActivity(state: LiveActivityState, config?: LiveActivityConfig): string | undefined`**:
  Start a new live activity. Takes a `state` configuration object for initial activity state and an optional `config` object to customize appearance or behavior. It returns the `ID` of the created live activity, which should be stored for future reference. If the live activity can't be created (eg. on android or iOS lower than 16.2), it will return `undefined`.

- **`updateActivity(id: string, state: LiveActivityState)`**:
  Update an existing live activity. The `state` object should contain updated information. The `activityId` indicates which activity should be updated.

- **`stopActivity(id: string, state: LiveActivityState)`**:
  Terminate an ongoing live activity. The `state` object should contain the final state of the activity. The `activityId` indicates which activity should be stopped.

### Handling Push Notification Tokens

- **`addActivityPushToStartTokenListener(listener: (event: ActivityPushToStartTokenReceivedEvent) => void): EventSubscription | undefined`**:
  Subscribe to changes in the push to start token for starting live acitivities with push notifications.
- **`addActivityTokenListener(listener: (event: ActivityTokenReceivedEvent) => void): EventSubscription | undefined`**:
  Subscribe to changes in the push notification token associated with live activities.

### Deep linking

When starting a new live activity, it's possible to pass `deepLinkUrl` field in `config` object. This usually should be a path to one of your screens. If you are using @react-navigation in your project, it's easiest to enable auto linking:

```typescript
const prefix = Linking.createURL('')

export default function App() {
  const url = Linking.useLinkingURL()
  const linking = {
    enabled: 'auto' as const,
    prefixes: [prefix],
  }
}

// Then start the activity with:
LiveActivity.startActivity(state, {
  deepLinkUrl: '/order',
})
```

URL scheme will be taken automatically from `scheme` field in `app.json` or fall back to `ios.bundleIdentifier`.

### State Object Structure

The `state` object should include:

```typescript
{
  title: string;
  subtitle?: string;
  date?: number; // Set as epoch time in milliseconds. This is used as an end date in a timer.
  imageName?: string; // Matches the name of the image in 'assets/liveActivity'
  dynamicIslandImageName?: string; // Matches the name of the image in 'assets/liveActivity'
};
```

### Config Object Structure

The `config` object should include:

```typescript
{
   backgroundColor?: string;
   titleColor?: string;
   subtitleColor?: string;
   progressViewTint?: string;
   progressViewLabelColor?: string;
   deepLinkUrl?: string;
   timerType?: DynamicIslandTimerType; // "circular" | "digital" - defines timer appereance on the dynamic island
};
```

### Activity updates

`LiveActivity.addActivityUpdatesListener` API allows to subscribe to changes in live activity state. This is useful for example when you want to update the live activity with new information. Handler will receive an `ActivityUpdateEvent` object which contains information about new state under `activityState` property which is of `ActivityState` type, so the possible values are: `'active'`, `'dismissed'`, `'pending'`, `'stale'` or `'ended'`. Apart from this property, the event also contains `activityId` and `activityName` which can be used to identify the live activity.

## Example Usage

Managing a live activity:

```typescript
const state: LiveActivity.LiveActivityState = {
  title: 'Title',
  subtitle: 'This is a subtitle',
  date: new Date(Date.now() + 60 * 1000 * 5).getTime(),
  imageName: 'live_activity_image',
  dynamicIslandImageName: 'dynamic_island_image',
}

const config: LiveActivity.LiveActivityConfig = {
  backgroundColor: '#FFFFFF',
  titleColor: '#000000',
  subtitleColor: '#333333',
  progressViewTint: '#4CAF50',
  progressViewLabelColor: '#FFFFFF',
  deepLinkUrl: '/dashboard',
  timerType: 'circular',
}

const activityId = LiveActivity.startActivity(state, config)
// Store activityId for future reference
```

This will initiate a live activity with the specified title, subtitle, image from your configured assets folder and a time to which there will be a countdown in a progress view.

Subscribing to push token changes:

```typescript
useEffect(() => {
  const updateTokenSubscription = LiveActivity.addActivityTokenListener(
    ({ activityID: newActivityID, activityName: newName, activityPushToken: newToken }) => {
      // Send token to a remote server to update live activity with push notifications
    }
  )
  const startTokenSubscription = LiveActivity.addActivityPushToStartTokenListener(
    ({ activityPushToStartToken: newActivityPushToStartToken }) => {
      // Send token to a remote server to start live activity with push notifications
    }
  )

  return () => {
    updateTokenSubscription?.remove()
    startTokenSubscription?.remove()
  }
}, [])
```

> [!NOTE]
> Receiving push token may not work on simulators. Make sure to use physical device when testing this functionality.

## Push notifications

By default, starting and updating live activity is possible only via API. If you want to have possibility to start or update live activity using push notifications, you can enable that feature by adding `"enablePushNotifications": true` in the plugin config in your `app.json` or `app.config.ts` file.

> [!NOTE]
> PushToStart works only for iOS 17.2 and higher.

Example payload for starting live activity:

```json
{
  "aps": {
    "event": "start",
    "content-state": {
      "title": "Live activity title!",
      "subtitle": "Live activity subtitle.",
      "timerEndDateInMilliseconds": 1754410997000,
      "imageName": "live_activity_image",
      "dynamicIslandImageName": "dynamic_island_image"
    },
    "timestamp": 1754491435000, // timestamp of when the push notification was sent
    "attributes-type": "LiveActivityAttributes",
    "attributes": {
      "name": "Test",
      "backgroundColor": "001A72",
      "titleColor": "EBEBF0",
      "subtitleColor": "FFFFFF75",
      "progressViewTint": "38ACDD",
      "progressViewLabelColor": "FFFFFF",
      "deepLinkUrl": "/dashboard",
      "timerType": "digital"
    },
    "alert": {
      "title": "",
      "body": "",
      "sound": "default"
    }
  }
}
```

Example payload for updating live activity:

```json
{
  "aps": {
    "event": "update",
    "content-state": {
      "title": "Hello",
      "subtitle": "World",
      "timerEndDateInMilliseconds": 1754064245000,
      "imageName": "live_activity_image",
      "dynamicIslandImageName": "dynamic_island_image"
    },
    "timestamp": 1754063621319 // timestamp of when the push notification was sent
  }
}
```

Where `timerEndDateInMilliseconds` value is a timestamp in milliseconds corresponding to the target point of the counter displayed in live activity view.

## Image support

Live activity view also supports image display. There are two dedicated fields in the `state` object for that:

- `imageName`
- `dynamicIslandImageName`

The value of each field can be:

- a string which maps to an asset name
- a URL to remote image - currently, it's possible to use this option only via API, but we plan on to add that feature to push notifications as well. It also requires adding "App Groups" capability to both "main app" and "live activity" targets.
