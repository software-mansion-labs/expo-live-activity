import { ConfigPlugin, IOSConfig, withPlugins } from "expo/config-plugins";
import { withConfig } from "./withConfig";
import { withPodfile } from "./withPodfile";

import { withXcode } from "./withXcode";
import { withWidgetExtensionEntitlements } from "./withWidgetExtensionEntitlements";

const withWidgetsAndLiveActivities: ConfigPlugin = (
  config
) => {
  const deploymentTarget = "16.2";
  const moduleFileName = "ExpoNativeConfigurationModule.swift"
  const attributesFileName = "LiveActivityAttributes.swift"

  const targetName = `${IOSConfig.XcodeUtils.sanitizedName(
    config.name
  )}LiveActivity`; // Widgets => LiveActivity
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
        // widgetsFolder,
        moduleFileName,
        attributesFileName,
      },
    ],
    [withWidgetExtensionEntitlements, { targetName }],
    [withPodfile, { targetName }],
    [withConfig, { targetName, bundleIdentifier }],
  ]);

  return config;
};

export default withWidgetsAndLiveActivities;
