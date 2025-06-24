# expo-live-activity

`expo-live-activity` is a React Native module designed for use with Expo to manage and display live activities on iOS devices. This module leverages the exciting new Live Activities feature introduced in iOS 16, allowing developers to deliver timely updates right on the lock screen.

## Features
- Start, update, and stop live activities directly from your React Native application.
- Easy integration with a comprehensive API.
- Custom image support within live activities with a pre-configured path.

## Installation

To begin using `expo-live-activity`, follow the installation and configuration steps outlined below:

### Step 1: Installation

Run the following command to add the expo-live-activity module to your project:

```sh
npm install expo-live-activity
```

### Step 2: Config Plugin Setup

The module comes with a built-in config plugin that creates target in ios with all the necessary files. The images used in live activities should be added to a pre-defined folder in your assets directory.

1. **Add the config plugin to your app.json or app.config.js:**:
   ```json
   {
      "expo": {
         "plugins": ["expo-live-activity"]
      }
   }
   ```

2. **Assets configuration**:
   Place images intended for live activities in the `assets/live-activity` folder. The plugin manages these assets automatically.


### Step 3: Usage in Your React Native App

Import the functionalities provided by the `expo-live-activity` module in your JavaScript or TypeScript files:

```javascript
import * as LiveActivity from "expo-live-activity";
```

## API

`expo-live-activity` module exports three primary functions to manage live activities:

- **`startActivity(state)`**:
  Start a new live activity. Takes a configuration object `state` for initial activity state. It returns the id of the created live activity.

- **`updateActivity(activityId, state)`**:
  Update an existing live activity. The `state` object should contain updated information. The `activityId` indicates which activity should be updated.

- **`stopActivity(state)`**:
  Terminate an ongoing live activity. The `state` object should contain the final state of the activity. The `activityId` indicates which activity should be stopped.

### State Object Structure
The `state` object should include::

```javascript
   {
      title: string,
      subtitle: string,
      date: number, // Set as epoch time in milliseconds
      imageName: string, // Matches the name of the image in 'assets/live-activity'
    };
```

## Example Usage

```javascript
const state = {
   title: "Title",
   subtitle: "This is a subtitle",
   date: new Date(Date.now() + 60 * 1000 * 5).getTime(),
   imageName: "live_activity_image",
};
const activityId = LiveActivity.startActivity(state);
// Store activityId for future reference
```

This will initiate a live activity with the specified title, subtitle, image from your configured assets folder and a time to which there will be a countdown in a progress view. The activity id returned by the function should be stored and used later to stop or update the activity.
