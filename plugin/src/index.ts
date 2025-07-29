import { IOSConfig, withPlugins } from "expo/config-plugins";
import type { LiveActivityConfigPlugin } from "./types";
import { withConfig } from "./withConfig";
import { withPodfile } from "./withPodfile";
import { withXcode } from "./withXcode";
import { withWidgetExtensionEntitlements } from "./withWidgetExtensionEntitlements";
import { withPushNotifications } from "./withPushNotifications";

const withWidgetsAndLiveActivities: LiveActivityConfigPlugin = (config, props) => {
  const deploymentTarget = "16.2";
  const targetName = `${IOSConfig.XcodeUtils.sanitizedName(
    config.name,
  )}LiveActivity`;
  const bundleIdentifier = `${config.ios?.bundleIdentifier}.${targetName}`;

  config.ios = {
    ...config.ios,
    infoPlist: {
      ...config.ios?.infoPlist,
      NSSupportsLiveActivities: true,
      NSSupportsLiveActivitiesFrequentUpdates: false,
    },
  };

  config = withPlugins(config, [
    [
      withXcode,
      {
        targetName,
        bundleIdentifier,
        deploymentTarget,
      },
    ],
    [withWidgetExtensionEntitlements, { targetName }],
    [withPodfile, { targetName }],
    [withConfig, { targetName, bundleIdentifier }],
  ]);

  if (props?.enablePushNotifications) {
    config = withPushNotifications(config);
  }

  return config;
};

export default withWidgetsAndLiveActivities;
