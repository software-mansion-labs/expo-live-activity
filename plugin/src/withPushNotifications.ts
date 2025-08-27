import { ConfigPlugin, withEntitlementsPlist, withInfoPlist } from '@expo/config-plugins'

export const withPushNotifications: ConfigPlugin = (config) =>
  withInfoPlist(
    withEntitlementsPlist(config, (mod) => {
      const profile = process.env.EAS_BUILD_PROFILE?.toLowerCase()
      const desiredAps = profile === 'production' || profile === 'release' ? 'production' : 'development'

      // Only set if not already defined to avoid overriding project settings
      if (!mod.modResults['aps-environment']) {
        mod.modResults['aps-environment'] = desiredAps
      }
      return mod
    }),
    (mod) => {
      mod.modResults['ExpoLiveActivity_EnablePushNotifications'] = true
      return mod
    }
  )
