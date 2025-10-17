import { withPlugins } from 'expo/config-plugins'

import type { LiveActivityConfigPlugin } from './types'
import { withConfig } from './withConfig'
import withPlist from './withPlist'
import { withPushNotifications } from './withPushNotifications'
import { withWidgetExtensionEntitlements } from './withWidgetExtensionEntitlements'
import { withXcode } from './withXcode'

const withWidgetsAndLiveActivities: LiveActivityConfigPlugin = (config, props) => {
  const deploymentTarget = '16.2'
  const targetName = 'LiveActivity'
  const bundleIdentifier = `${config.ios?.bundleIdentifier}.${targetName}`

  config.ios = {
    ...config.ios,
    infoPlist: {
      ...config.ios?.infoPlist,
      NSSupportsLiveActivities: true,
      NSSupportsLiveActivitiesFrequentUpdates: false,
    },
  }

  config = withPlugins(config, [
    withPlist,
    [
      withXcode,
      {
        targetName,
        bundleIdentifier,
        deploymentTarget,
      },
    ],
    [withWidgetExtensionEntitlements, { targetName }],
    [withConfig, { targetName, bundleIdentifier }],
  ])

  if (props?.enablePushNotifications) {
    config = withPushNotifications(config)
  }

  return config
}

export default withWidgetsAndLiveActivities
