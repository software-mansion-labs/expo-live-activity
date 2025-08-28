import { ConfigPlugin, withEntitlementsPlist, withInfoPlist } from '@expo/config-plugins'

export const withPushNotifications: ConfigPlugin = (config) =>
  withInfoPlist(
    withEntitlementsPlist(config, (mod) => {
      mod.modResults['aps-environment'] = 'development'
      return mod
    }),
    (mod) => {
      mod.modResults['ExpoLiveActivity_EnablePushNotifications'] = true
      return mod
    }
  )
