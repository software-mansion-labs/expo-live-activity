import { ConfigPlugin, IOSConfig, withPlugins } from "expo/config-plugins";
import { withConfig } from "./withConfig";
import { withPodfile } from "./withPodfile";

import { withXcode } from "./withXcode";
import { withWidgetExtensionEntitlements } from "./withWidgetExtensionEntitlements";
import { withPushNotifications } from "./withPushNotifications";

const withWidgetsAndLiveActivities: ConfigPlugin<{
  enablePushNotificationsEntitlement?: boolean;
}> = (
  config,
  {
    enablePushNotificationsEntitlement = false
  } = {}
) => {
  const deploymentTarget = "16.2";
  const targetName = `${IOSConfig.XcodeUtils.sanitizedName(
    config.name
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

  if (enablePushNotificationsEntitlement) {
    console.log("Add push notifications")
    config = withPushNotifications(config)
  }

  return config;
};

export default withWidgetsAndLiveActivities;
