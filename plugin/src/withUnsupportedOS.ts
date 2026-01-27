import { ConfigPlugin, withInfoPlist } from '@expo/config-plugins'

export const withUnsupportedOS: ConfigPlugin<{ silentOnUnsupportedOS: boolean }> = (
  config,
  { silentOnUnsupportedOS }
) =>
  withInfoPlist(config, (mod) => {
    mod.modResults['ExpoLiveActivity_SilentOnUnsupportedOS'] = silentOnUnsupportedOS
    return mod
  })
